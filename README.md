FlagIt: flag lines with icons (Vim plugin)
=========================================

FlagIt is a Vim plugin that prefixes lines with icons.

![FlagIt screenshot](https://github.com/paulrouget/flagit/raw/master/screenshot.png)

Usage
=====
- `:FlagIt flagName [line number]` toggle a flag. If no line number is provided, the current line is used.
- `:FlagList` list all avaible flags.
- `:FlagDemo` just a way to draw all kind of flags (debug).


Configuration
=============

- `g:Fi_OnlyText` if `1`, force text mode.
- `g:Fi_ShowMenu` if `1` and Gui avaible and `g:Fi_OnlyText` is `0`, a menu is added to the toolbar.
- `g:Fi_Flags` a dictionnary of flag definitions.
- A definition is declared as:
```vim
name : [path, fallback, isUniq, [optional] signArgs]`
```
  - `name` a uniq identifier.
  - `path` path to the image. The image will be drawn as a pixmap (if GUI avaible and `g:Fi_OnlyText` is `0`).
  - `fallback` one or two character Drawn if text mode or  `g:Fi_OnlyText` is `1`.
  - `uniq` if `1`, only one instance of this flag will be drawn (any other instance will be disabled). Useful to draw a cursor for example.
  - `signArgs` additional arguments to the sign definition (`:sign define`; see `:help sign`). Useful for theming.

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

Save flags (Modelines ? session ? dedicated file ?)

