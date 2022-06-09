function! nodeautolog#ShowNodeLog()
  lcd %:p:h
  split \| terminal node-autolog %
endfunction

function! nodeautolog#MarkLineToLog()
  A /*log*/
endfunction
