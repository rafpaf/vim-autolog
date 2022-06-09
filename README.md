This plugin allows you to iterate more quickly in javascript by creating a
shortcut key for checking the output of a line of code.

Add this to your .vimrc:

```vim
map <leader>n :ShowNodeLog<CR>
map <leader>N :MarkLineToLog<CR>
```

Type <leader>N to mark to a line of code with the comment `/*log*/`. Type <leader>n to show the output.

For example, suppoe your script has a line like this:

```js
isInDict("cat") === true;
```

You can mark it by typing <leader>N, and then it'll look like this:

```js
isInDict("cat") === true; /*log*/
```

Then when you type <leader>n, you'll see this at the bottom of the screen:

```
true          isInDict("cat") === true
```
