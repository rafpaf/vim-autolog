let s:current_file=expand('%:p')

function! nodeautolog#ShowNodeLog()
  
lcd %:p:h
python3 << endpy
import vim
import sys
import re
import json
import subprocess

filename = vim.eval("s:current_file")
#print(filename)

# First see if we should autolog this file or a related file (this is useful
# when using TypeScript)
f = open(filename, "r")
lines = f.readlines()
for line in lines:
    if re.match("^// run as: ", line):
        line = re.sub("// run as: ", "", line)
        f = open(line, "r")
        lines = f.readlines()

script = ""

for line in lines:
    # Additional whitespace at end of line does not matter.
    line = line.rstrip()
    mark="/\*log\*/"
    marked = re.match('.* %s$' % mark, line)
    # If the line is not marked, just print it
    if not marked:
        script = "%s\n%s" % (script, line)
    else:
        line = re.sub('; %s$' % mark,'', line)
        line = re.sub('%s$' % mark,'', line)
        # Don't log this line if it is a comment
        nested_comment = line.startswith("// ")
        if nested_comment:
            script = "%s\n%s" % (script, line)
        else:
            escaped_line = json.dumps(line)
            expr = line
            # To the script, add the value of the expression, then two tabs, then the expression
            script = "%s\nconsole.log(%s, '        ', %s)" % (script, expr, escaped_line)

output = subprocess.run(["node"], text=True, input=script, capture_output=True).stdout
print(output)
endpy
endfunction

function! nodeautolog#MarkLineToLog()
  execute ":normal! A /*log*/"
endfunction
