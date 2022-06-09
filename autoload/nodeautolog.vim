function! nodeautolog#ShowNodeLog()
  lcd %:p:h
  nodeautolog#testPython()
  "split \| terminal node-autolog %
endfunction

function! nodeautolog#MarkLineToLog()
  A /*log*/
endfunction

function! nodeautolog#testPython()
  python3 << endpy
    print('hi')
  endpy
endfunction

function! nodeautolog#RunInNode()
  python3 << endpy
    import sys
    import re
    import json
    import subprocess

    colorize = True

    filename = sys.argv[1]

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

    if colorize:
        script += "const chalk = require('chalk');"
    for line in lines:
        # Additional whitespace at end of line does not matter.
        line = line.rstrip()
        mark="/\*log\*/"
        marked = re.match('.* %s$' % mark, line)
        # If the line is not marked, just print it
        if not marked:
            script += line
        else:
            line = re.sub('; %s$' % mark,'', line)
            line = re.sub('%s$' % mark,'', line)
            # Don't log this line if it is a comment
            nested_comment = line.startswith("// ")
            if nested_comment:
                script += line
            else:
                escaped_line = json.dumps(line)
                if colorize:
                    expr = "chalk.blue(%s)" % line
                else:
                    expr = line
                # To the script, add the value of the expression, then two tabs, then the expression
                script = "%s\nconsole.log(%s, '\t\t', %s)" % (script, expr, escaped_line)

    subprocess.run(["node"], text=True, input=script)
  endpy

endfunction
