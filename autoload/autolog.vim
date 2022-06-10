function! autolog#ShowLog()

let s:current_file=expand('%:p')
  
lcd %:p:h
python3 << endpy
import vim
import sys
import re
import json
import subprocess

languages = {
    'node': {
        'extensions': ['.js','.ts'],
        'command': 'node',
        'single_line_comment_prefix': "//",
        'mark': "/*log*/",
        'strip_from_end': ";",
        'make_log_command': lambda line: "console.log(%s, '        ', %s)" % (line, json.dumps(line))
    },
    'elixir': {
        'extensions': ['.ex'],
        'command': 'iex',
        'single_line_comment_prefix': "#",
        'mark': "# log",
        'strip_from_end': ";",
        'make_log_command': lambda line: "IO.puts(\"#{%s}        %s\")" % (line, line)
        }
}

filename = vim.eval("s:current_file")
extension = re.findall("\.[a-z]*$", filename)[0]
lang = [languages[l] for l in languages if extension in languages[l]['extensions']][0]
print(lang['mark'])

# First see if we should autolog this file or a related file (this is useful
# when using TypeScript)
f = open(filename, "r")
lines = f.readlines()
run_as_regexp = "^%s run as: " % lang['single_line_comment_prefix']
for line in lines:
    if re.match(run_as_regexp, line):
        line = line.rstrip()
        run_as_filename = re.sub(run_as_regexp, "", line)
        f = open(run_as_filename, "r")
        lines = f.readlines()

script = ""

for line in lines:
    # Additional whitespace at end of line does not matter.
    line = line.rstrip()
    marked = re.match('.* %s$' % re.escape(lang['mark']), line) != None
    # If the line is not marked, just print it
    if not marked:
        script = "%s\n%s" % (script, line)
    else:
        line = re.sub('; %s$' % lang['mark'],'', line)
        line = re.sub('%s$' % lang['mark'],'', line)
        # Don't log this line if it is a comment
        nested_comment = line.startswith(lang['single_line_comment_prefix'])
        if nested_comment:
            script = "%s\n%s" % (script, line)
        else:
            # TODO: make this language-specific
            # To the script, add the value of the expression, then two tabs, then the expression
            log_command = lang['make_log_command'](line)
            script = "%s\n%s" % (script, log_command)

output = subprocess.run([lang['command']], text=True, input=script, capture_output=True).stdout
print(output)
endpy
endfunction

function! autolog#MarkLineToLog()
    if (&ft=='elixir')
        execute ":normal! A # log"
    endif
    if (&ft=='javascript')
        execute ":normal! A /*log*/"
    endif
endfunction
