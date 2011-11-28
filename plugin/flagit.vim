" FlagIt - https://github.com/paulrouget/flagit
" 2006-06-21, @paulrouget
"
" Thanks to Brian Wang's VisualMark.vim: http://www.vim.org/scripts/script.php?script_id=1026

" ---------------------------------------------------------------------
" Public Command:

command -nargs=+ FlagIt :call s:FlagALine(<f-args>)
command -nargs=* UnFlag :call s:UnFlag(<f-args>) "Do we really need to expose this?
command FlagDemo :call FlagDemo()
command FlagList :call FlagList()


" ---------------------------------------------------------------------
" Public Variable:

if !exists('g:Fi_ShowMenu')
	let g:Fi_ShowMenu = 0
endif
if !exists('g:Fi_OnlyText')
	let g:Fi_OnlyText = 1
endif
if !exists('g:Fi_Flags')
	let g:Fi_Flags = {}
endif

" ---------------------------------------------------------------------
" Add signs:

let tbItem = 1
for key in keys(g:Fi_Flags)
	if has("gui_running") && !g:Fi_OnlyText
		exe ":sign define ".key." icon=".g:Fi_Flags[key][0]." ".g:Fi_Flags[key][3]
		if g:Fi_ShowMenu
			exe ':menu icon='.g:Fi_Flags[key][0].' ToolBar.flag'.tbItem.' :FlagIt '.key.'<CR>'
			let tbItem += 1
		endif
	else
		exe ":sign define ".key." text=".g:Fi_Flags[key][1]." ".g:Fi_Flags[key][3]
	endif
endfor

let s:Fi_FlagId = 1

" ---------------------------------------------------------------------
" List all signs:

fun! FlagList()
	for key in keys(g:Fi_Flags)
		echo key
	endfor
endfunction

" ---------------------------------------------------------------------
" Add flags i to line i, just for test:

fun! FlagDemo()
	let line = 1
	for key in keys(g:Fi_Flags)
		:call s:FlagALine(key, line)
		let line += 1
	endfor
endfunction

" ---------------------------------------------------------------------
" Flag a line:

fun! s:FlagALine(flag, ...)
	if a:0 == 0
		"if no line specified, use current line
		let a:line = line(".")
	else
		let a:line = a:1
	endif

	let sign_list = s:GetVimCmdOutput('sign place buffer=' . winbufnr(0))

	let aFlagId = s:Fi_get_flagid_from_line(sign_list, a:line)
	if aFlagId != ""
		exe ':sign unplace '.aFlagId.' buffer=' . winbufnr(0)
		return
	endif

	let aFlagId = ""
	if g:Fi_Flags[a:flag][2]
		let aFlagId = s:Fi_get_flagid_from_flag(sign_list, a:flag)
	endif
	exe ':sign place '.s:Fi_FlagId.' line='.a:line.' name='.a:flag.' buffer=' . winbufnr(0)
	let s:Fi_FlagId += 1
	if aFlagId != ""
		exe ':sign unplace '.aFlagId.' buffer=' . winbufnr(0)
	endif
endfun

" ---------------------------------------------------------------------
" Remove flags:

fun! s:UnFlag(...)
	if a:0 == 0
		for key in keys(g:Fi_Flags)
			:call s:UnFlag(key)
		endfor
	else
		while 1
			let sign_list = s:GetVimCmdOutput('sign place buffer=' . winbufnr(0))
			let aFlagId = s:Fi_get_flagid_from_flag(sign_list, a:1)
			if aFlagId == ""
				break
			endif
			exe ':sign unplace '.aFlagId.' buffer=' . winbufnr(0)
		endwhile
	endif
endfun

" ---------------------------------------------------------------------
" Get flagId from a flag name:

fun! s:Fi_get_flagid_from_flag(string, flag)
	let tmp = 0
	while 1
		let line_str_index = -1
		let line_str_index = match(a:string, "name=", tmp)
		if line_str_index <= 0
			return ""
		endif
		let equal_sign_index = match(a:string, "=", line_str_index)
		let space_index      = match(a:string, "\n", equal_sign_index)
		let flag_name = strpart(a:string, equal_sign_index + 1, space_index - equal_sign_index - 1)
		if flag_name == a:flag
			let line_str_index = match(a:string, "id=", tmp)
			let equal_sign_index = match(a:string, "=", line_str_index)
			let space_index      = match(a:string, " ", equal_sign_index)
			let flagId = strpart(a:string, equal_sign_index + 1, space_index - equal_sign_index - 1)
			return flagId
		endif
		let tmp = space_index
	endwhile
	return ""
endfun

" ---------------------------------------------------------------------
" Get flagId from a line number:

fun! s:Fi_get_flagid_from_line(string, line)
	let tmp = 0
	while 1
		let line_str_index = -1
		let line_str_index = match(a:string, "line=", tmp)
		if line_str_index <= 0
			return ""
		endif
		let equal_sign_index = match(a:string, "=", line_str_index)
		let space_index      = match(a:string, " ", equal_sign_index)
		let line_nb = strpart(a:string, equal_sign_index + 1, space_index - equal_sign_index - 1)
		if line_nb == a:line
			let line_str_index = match(a:string, "id=", space_index)
			let equal_sign_index = match(a:string, "=", line_str_index)
			let space_index      = match(a:string, " ", equal_sign_index)
			let flagId = strpart(a:string, equal_sign_index + 1, space_index - equal_sign_index - 1)
			return flagId
		endif
		let tmp = space_index
	endwhile
	return ""
endfun


" ---------------------------------------------------------------------
" Stolen from Hari Krishna Dara's genutils.vim (http://vim.sourceforge.net/scripts/script.php?script_id=197)
" to ease the scripts dependency issue
fun! s:GetVimCmdOutput(cmd)
	let old_lang = v:lang
	exec ":lan mes en_US"
	let v:errmsg = ''
	let output   = ''
	let _z       = @z
	try
		redir @z
		silent exe a:cmd
	catch /.*/
		let v:errmsg = substitute(v:exception, '^[^:]\+:', '', '')
	finally
		redir END
		if v:errmsg == ''
			let output = @z
		endif
		let @z = _z
	endtry
	exec ":lan mes " . old_lang
	return output
endfun

