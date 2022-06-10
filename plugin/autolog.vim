" Title:        autolog
" Description:  Display js and elixir output conveniently, like Quokka or Codi
" Last Change:  June 9, 2022
" Maintainer:   Raphael Krut-Landau <https://github.com/rafpaf>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_autolog")
    finish
endif
let g:loaded_autolog = 1

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=0 MarkLineToLog call autolog#MarkLineToLog()
command! -nargs=0 ShowAutoLog call autolog#ShowLog()
