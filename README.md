FlagIt: flag lines with icons (Vim plugin)
=========================================

FlagIt is a Vim plugin that adds icons (or text) at the beginning of any marked line.

![FlagIt screenshot](https://github.com/paulrouget/flagit/raw/master/screenshot.png)

Usage
=====
- `:FlagIt flagName [line number]` Toggle a flag. If line number is not provided, the current line is used.
- `:FlagList` List all avaible flags
- `:FlagDemo` Just a way to draw all kind of flags (for tests)




Configuration
=============

- `g:Fi_OnlyText` If 1, force text mode.
- `g:Fi_ShowMenu` If 1 and Gui avaible and g:Fi_OnlyText is 0, a menu is added to the toolbar.
- `g:Fi_Flags` A dictionnary of flag definitions.
- A definition is declared as: `name : [path, fallback, isUniq, [optional] signArgs]`
  - `name`: an uniq identifier
  - `path`: The path to an image. The image will be drawn as a pixmap (if GUI avaible and g:Fi_OnlyText is 0).
  - `fallback`: One or two character. Drawn if text mdoe or  g:Fi_OnlyText is 1.
  - `uniq`: If 1, only one instance of this flag will be drawn (any other instance will be disabled). Useful to draw a cursor for example.
  - `signArgs`: additional argumens to the sign definition (see :sign define). Useful for theming.

Example
=======

```vim
map <F1> :FlagIt arrow<CR>
map <F2> :FlagIt function<CR>
map <F3> :FlagIt warning<CR>
map <F4> :FlagIt error<CR>
map <F5> :FlagIt step<CR>

let icons_path = "/home/paul/.vim/signs/tango/"
let g:Fi_Flags = { "arrow" : [icons_path."16.png", "> ", 1, "texthl=Title"],
      \ "function" : [icons_path."17.png", "+ ", 0, "texthl=Comment"],
      \ "warning" : [icons_path."8.png", "! ", 0, "texthl=StatusLine linehl=StatusLine"],
      \ "error" : [icons_path."4.png", "XX", "true", "texthl=ErrorMsg linehl=ErrorMsg"],
      \ "step" : [icons_path."5.png", "..", "true", ""] }
let g:Fi_OnlyText = 0
let g:Fi_ShowMenu = 0
```

TODO
====

save flags (Modelines ? session ? dedicated file ?)
