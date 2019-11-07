" Some basics:
	let mapleader = ","
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number
	set relativenumber
	set foldmethod=syntax
	set foldtext=MyFoldText()
	"set foldtext=v:folddashes.substitute(getline(v:foldstart),'/\\*\\\|\\*/\\\|{{{\\d\\=','','g')
	set undodir=/tmp//
	set undofile

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow
	set splitright

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Open the selected text in a split (i.e. should be a file).
	map <leader>o "oyaW:sp <C-R>o<CR>
	xnoremap <leader>o "oy<esc>:sp <C-R>o<CR>
	vnoremap <leader>o "oy<esc>:sp <C-R>o<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Copy selected text to system clipboard (requires gvim installed):
	vnoremap <C-c> "*y :let @+=@*<CR>

" Enable autocompletion:
	set wildmode=longest:full,full
	set wildmenu

" Automatically deletes all tralling whitespace on save.
	fun! StripTrailingWhitespace()
		if &ft =~ 'md'
			return
		endif
		%s/\s\+$//e
	endfun
	autocmd FileType md BufWritePre * call StripTrailingWhitespace()

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Color
	hi Visual ctermfg=0 ctermbg=7
	hi Search ctermfg=0
	hi Comment ctermfg=27
	hi MatchParent ctermbg=238
	hi SpellBad ctermfg=0
	hi PmenuSbar ctermfg=0
	hi DiffDelete ctermfg=0
	hi Folded ctermfg=255 ctermbg=235
	hi FoldColumn ctermfg=0
	hi SpellCap ctermfg=0
	" statusline fg is bg and viceversa
	hi StatusLine ctermfg=black ctermbg=grey
	hi StatusLineNC ctermfg=233 ctermbg=grey
	hi User3 ctermfg=grey ctermbg=235

" Foldtext function
	function! MyFoldText()
		let line = getline(v:foldstart)
		if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
			let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
			let linenum = v:foldstart + 1
			while linenum < v:foldend
				let line = getline( linenum )
				let comment_content = substitute( line, '^\([ \t\/\*]*\)\(.*\)$', '\2', 'g' )
				if comment_content != ''
					break
				endif
				let linenum = linenum + 1
			endwhile
			let sub = initial . ' ' . comment_content
		else
			let sub = line
			let startbrace = substitute( line, '^.*{[ \t]*$', '{', 'g')
			if startbrace == '{'
				let line = getline(v:foldend)
				let endbrace = substitute( line, '^[ \t]*}\(.*\)$', '}', 'g')
				if endbrace == '}'
					let sub = sub.substitute( line, '^[ \t]*}\(.*\)$', '...}\1', 'g')
				endif
			endif
		endif
		let n = v:foldend - v:foldstart + 1
		let info = " " . n . " lines"
		let sub = sub . "                                                                                                                  "
		let num_w = getwinvar( 0, '&number' ) * getwinvar( 0, '&numberwidth' )
		let fold_w = getwinvar( 0, '&foldcolumn' )
		let sub = strpart( sub, 0, winwidth(0) - strlen( info ) - num_w - fold_w - 1 )
		return sub . info
	endfunction

" External function
	:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g

" filetype
	autocmd FileType typescript.tsx setlocal shiftwidth=2 softtabstop=2 expandtab
