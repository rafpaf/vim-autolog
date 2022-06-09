function! autolog#ShowNodeLog()
  lcd %:p:h
  split \| terminal node-autolog %
endfunction

function! autolog#MarkLineToLog()
  A /*log*/
endfunction
