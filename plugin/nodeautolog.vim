" Title:        NodeAutolog
" Description:  Display js output conveniently, like Quokka
" Last Change:  June 9, 2022
" Maintainer:   Raphael Krut-Landau <https://github.com/rafpaf>

" Prevents the plugin from being loaded multiple times. If the loaded
" variable exists, do nothing more. Otherwise, assign the loaded
" variable and continue running this instance of the plugin.
if exists("g:loaded_nodeautolog")
    finish
endif
let g:loaded_nodeautolog = 1

" Exposes the plugin's functions for use as commands in Vim.
command! -nargs=0 MarkLineToLog call nodeautolog#MarkLineToLog()
command! -nargs=0 ShowNodeLog call nodeautolog#ShowNodeLog()
