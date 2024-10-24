" Script to generate testdir/opt_test.vim from optiondefs.h

set cpo=&vim

" Only do this when build with the +eval feature.
if 1

try

set nomore

const K_KENTER = -16715

" The terminal size is restored at the end.
" Clear out t_WS, we don't want to resize the actual terminal.
let script = [
      \ '" DO NOT EDIT: Generated with gen_opt_test.vim',
      \ '" Used by test_options.vim.',
      \ '',
      \ 'let save_columns = &columns',
      \ 'let save_lines = &lines',
      \ 'set t_WS=',
      \ ]

/#define p_term
let end = line('.')

" font name that works everywhere (hopefully)
let fontname = has('win32') ? 'fixedsys' : 'fixed'

" Two lists with values: values that work and values that fail.
" When not listed, "othernum" or "otherstring" is used.
" When both lists are empty, skip tests for the option.
" For boolean options, if non-empty a fixed test will be run, otherwise skipped.
let test_values = {
      "\ boolean options
      \ 'termguicolors': [
      \		has('vtp') && !has('vcon') && !has('gui_running') ? [] : [1],
      \		[]],
      \
      "\ number options
      \ 'cmdheight': [[1, 2, 10], [-1, 0]],
      \ 'cmdwinheight': [[1, 2, 10], [-1, 0]],
      \ 'columns': [[12, 80, 10000], [-1, 0, 10]],
      \ 'conceallevel': [[0, 1, 2, 3], [-1, 4, 99]],
      \ 'foldcolumn': [[0, 1, 4, 12], [-1, 13, 999]],
      \ 'helpheight': [[0, 10, 100], [-1]],
      \ 'history': [[0, 1, 100, 10000], [-1, 10001]],
      \ 'iminsert': [[0, 1, 2], [-1, 3, 999]],
      \ 'imsearch': [[-1, 0, 1, 2], [-2, 3, 999]],
      \ 'imstyle': [[0, 1], [-1, 2, 999]],
      \ 'lines': [[2, 24, 1000], [-1, 0, 1]],
      \ 'linespace': [[-1, 0, 2, 4, 999], ['']],
      \ 'numberwidth': [[1, 4, 8, 10, 11, 20], [-1, 0, 21]],
      \ 'regexpengine': [[0, 1, 2], [-1, 3, 999]],
      \ 'report': [[0, 1, 2, 9999], [-1]],
      \ 'scroll': [[0, 1, 2, 20], [-1, 999]],
      \ 'scrolljump': [[-100, -1, 0, 1, 2, 20], [-101, 999]],
      \ 'scrolloff': [[0, 1, 8, 999], [-1]],
      \ 'shiftwidth': [[0, 1, 8, 999], [-1]],
      \ 'sidescroll': [[0, 1, 8, 999], [-1]],
      \ 'sidescrolloff': [[0, 1, 8, 999], [-1]],
      \ 'tabstop': [[1, 4, 8, 12, 9999], [-1, 0, 10000]],
      \ 'textwidth': [[0, 1, 8, 99], [-1]],
      \ 'timeoutlen': [[0, 8, 99999], [-1]],
      \ 'titlelen': [[0, 1, 8, 9999], [-1]],
      \ 'updatecount': [[0, 1, 8, 9999], [-1]],
      \ 'updatetime': [[0, 1, 8, 9999], [-1]],
      \ 'verbose': [[-1, 0, 1, 8, 9999], ['']],
      \ 'wildchar': [[-1, 0, 100, 'x', '^Y', '^@', '<Esc>', '<t_xx>', '<', '^'],
      \		['', 'xxx', '<xxx>', '<t_xxx>', '<Esc', '<t_xx', '<C-C>',
      \		'<NL>', '<CR>', K_KENTER]],
      \ 'wildcharm': [[-1, 0, 100, 'x', '^Y', '^@', '<Esc>', '<', '^'],
      \		['', 'xxx', '<xxx>', '<t_xxx>', '<Esc', '<t_xx', '<C-C>',
      \		'<NL>', '<CR>', K_KENTER]],
      \ 'winheight': [[1, 10, 999], [-1, 0]],
      \ 'winminheight': [[0, 1], [-1]],
      \ 'winminwidth': [[0, 1, 10], [-1]],
      \ 'winwidth': [[1, 10, 999], [-1, 0]],
      \
      "\ string options
      \ 'ambiwidth': [['', 'single', 'double'], ['xxx']],
      \ 'background': [['', 'light', 'dark'], ['xxx']],
      \ 'backspace': [[0, 1, 2, 3, '', 'indent', 'eol', 'start', 'nostop',
      \		'eol,start', 'indent,eol,nostop'],
      \		[-1, 4, 'xxx']],
      \ 'backupcopy': [['yes', 'no', 'auto'], ['', 'xxx', 'yes,no']],
      \ 'backupext': [['xxx'], [&patchmode, '*']],
      \ 'belloff': [['', 'all', 'backspace', 'cursor', 'complete', 'copy',
      \		'ctrlg', 'error', 'esc', 'ex', 'hangul', 'insertmode', 'lang',
      \		'mess', 'showmatch', 'operator', 'register', 'shell', 'spell',
      \		'term', 'wildmode', 'copy,error,shell'],
      \		['xxx']],
      \ 'breakindentopt': [['', 'min:3', 'shift:4', 'shift:-2', 'sbr', 'list:5',
      \		'list:-1', 'column:10', 'column:-5', 'min:1,sbr,shift:2'],
      \		['xxx', 'min', 'min:x', 'min:-1', 'shift:x', 'sbr:1', 'list:x',
      \		'column:x']],
      \ 'browsedir': [['', 'last', 'buffer', 'current', './Xdir\ with\ space'],
      \		['xxx']],
      \ 'bufhidden': [['', 'hide', 'unload', 'delete', 'wipe'],
      \		['xxx', 'hide,wipe']],
      \ 'buftype': [['', 'nofile', 'nowrite', 'acwrite', 'quickfix', 'help',
      \		'terminal', 'prompt', 'popup'],
      \		['xxx', 'help,nofile']],
      \ 'casemap': [['', 'internal', 'keepascii', 'internal,keepascii'],
      \		['xxx']],
      \ 'cedit': [['', '^Y', '^@', '<Esc>', '<t_xx>'],
      \		['xxx', 'f', '<xxx>', '<t_xxx>', '<Esc', '<t_xx']],
      \ 'clipboard': [['', 'unnamed', 'unnamedplus', 'autoselect',
      \		'autoselectplus', 'autoselectml', 'html', 'exclude:vimdisplay',
      \		'autoselect,unnamed', 'unnamed,exclude:.*'],
      \		['xxx', 'exclude:\\ze*', 'exclude:\\%(']],
      \ 'colorcolumn': [['', '8', '+2', '1,+1,+3'], ['xxx', '-a', '1,', '1;']],
      \ 'comments': [['', 'b:#', 'b:#,:%'], ['xxx', '-']],
      \ 'commentstring': [['', '/*\ %s\ */'], ['xxx']],
      \ 'complete': [['', '.', 'w', 'b', 'u', 'U', 'i', 'd', ']', 't',
      \		'k', 'kspell', 'k/tmp/dir\\\ with\\\ space/*',
      \		's', 's/tmp/dir\\\ with\\\ space/*',
      \		'w,b,k/tmp/dir\\\ with\\\ space/*,s'],
      \		['xxx']],
      \ 'concealcursor': [['', 'n', 'v', 'i', 'c', 'nvic'], ['xxx']],
      \ 'completeopt': [['', 'menu', 'menuone', 'longest', 'preview', 'popup',
      \		'popuphidden', 'noinsert', 'noselect', 'fuzzy', 'menu,longest'],
      \		['xxx', 'menu,,,longest,']],
      \ 'completeitemalign': [['abbr,kind,menu', 'menu,abbr,kind'],
      \		['', 'xxx', 'abbr', 'abbr,menu', 'abbr,menu,kind,abbr',
      \		'abbr1234,kind,menu']],
      \ 'completepopup': [['', 'height:13', 'width:20', 'highlight:That',
      \		'align:item', 'align:menu', 'border:on', 'border:off',
      \		'width:10,height:234,highlight:Mine'],
      \		['xxx', 'xxx:99', 'height:yes', 'width:no', 'align:xxx',
      \		'border:maybe', 'border:1', 'border:']],
      \ 'completeslash': [['', 'slash', 'backslash'], ['xxx']],
      \ 'cryptmethod': [['', 'zip'], ['xxx']],
      \ 'cscopequickfix': [['', 's-', 'g-', 'd-', 'c-', 't-', 'e-', 'f-', 'i-',
      \		'a-', 's-,c+,e0'],
      \		['xxx', 's,g,d']],
      \ 'cursorlineopt': [['both', 'line', 'number', 'screenline',
      \		'line,number'],
      \		['', 'xxx', 'line,screenline']],
      \ 'debug': [['', 'msg', 'throw', 'beep'], ['xxx']],
      \ 'diffopt': [['', 'filler', 'context:0', 'context:999', 'iblank',
      \		'icase', 'iwhite', 'iwhiteall', 'horizontal', 'vertical',
      \		'closeoff', 'hiddenoff', 'foldcolumn:0', 'foldcolumn:12',
      \		'followwrap', 'internal', 'indent-heuristic', 'algorithm:myers',
      \		'algorithm:minimal', 'algorithm:patience',
      \		'algorithm:histogram', 'icase,iwhite'],
      \		['xxx', 'foldcolumn:xxx', 'algorithm:xxx', 'algorithm:']],
      \ 'display': [['', 'lastline', 'truncate', 'uhex', 'lastline,uhex'],
      \		['xxx']],
      \ 'eadirection': [['', 'both', 'ver', 'hor'], ['xxx', 'ver,hor']],
      \ 'encoding': [['latin1'], ['xxx', '']],
      \ 'eventignore': [['', 'WinEnter', 'WinLeave,winenter', 'all,WinEnter'],
      \		['xxx']],
      \ 'fileencoding': [['', 'latin1', 'xxx'], []],
      \ 'fileformat': [['', 'dos', 'unix', 'mac'], ['xxx']],
      \ 'fileformats': [['', 'dos', 'dos,unix'], ['xxx']],
      \ 'fillchars': [['', 'stl:x', 'stlnc:x', 'vert:x', 'fold:x', 'foldopen:x',
      \		'foldclose:x', 'foldsep:x', 'diff:x', 'eob:x', 'lastline:x',
      \		'stl:\ ,vert:\|,fold:\\,diff:x'],
      \		['xxx', 'vert:']],
      \ 'foldclose': [['', 'all'], ['xxx']],
      \ 'foldmethod': [['manual', 'indent', 'expr', 'marker', 'syntax', 'diff'],
      \		['', 'xxx', 'expr,diff']],
      \ 'foldopen': [['', 'all', 'block', 'hor', 'insert', 'jump', 'mark',
      \		'percent', 'quickfix', 'search', 'tag', 'undo', 'hor,jump'],
      \		['xxx']],
      \ 'foldmarker': [['((,))'], ['', 'xxx', '{{{,']],
      \ 'formatoptions': [['', 't', 'c', 'r', 'o', '/', 'q', 'w', 'a', 'n', '2',
      \		'v', 'b', 'l', 'm', 'M', 'B', '1', ']', 'j', 'p', 'vt', 'v,t'],
      \		['xxx']],
      \ 'guicursor': [['', 'n:block-Cursor'], ['xxx']],
      \ 'guifont': [['', fontname], []],
      \ 'guifontwide': [['', fontname], []],
      \ 'guifontset': [['', fontname], []],
      \ 'guioptions': [['', '!', 'a', 'P', 'A', 'c', 'd', 'e', 'f', 'i', 'm',
      \		'M', 'g', 't', 'T', 'r', 'R', 'l', 'L', 'b', 'h', 'v', 'p', 'F',
      \		'k', '!abvR'],
      \		['xxx', 'a,b']],
      \ 'helplang': [['', 'de', 'de,it'], ['xxx']],
      \ 'highlight': [['', 'e:Error'], ['xxx']],
      \ 'imactivatekey': [['', 'S-space'], ['xxx']],
      \ 'isfname': [['', '@', '@,48-52'], ['xxx', '@48']],
      \ 'isident': [['', '@', '@,48-52'], ['xxx', '@48']],
      \ 'iskeyword': [['', '@', '@,48-52'], ['xxx', '@48']],
      \ 'isprint': [['', '@', '@,48-52'], ['xxx', '@48']],
      \ 'jumpoptions': [['', 'stack'], ['xxx']],
      \ 'keymap': [['', 'accents'], ['/']],
      \ 'keymodel': [['', 'startsel', 'stopsel', 'startsel,stopsel'], ['xxx']],
      \ 'keyprotocol': [['', 'xxx:none', 'yyy:mok2', 'zzz:kitty'],
      \		['xxx', ':none', 'xxx:', 'x:non', 'y:mok3', 'z:kittty']],
      \ 'langmap': [['', 'xX', 'aA,bB'], ['xxx']],
      \ 'lispoptions': [['', 'expr:0', 'expr:1'], ['xxx', 'expr:x', 'expr:']],
      \ 'listchars': [['', 'eol:x', 'tab:xy', 'tab:xyz', 'space:x',
      \		'multispace:xxxy', 'lead:x', 'leadmultispace:xxxy', 'trail:x',
      \		'extends:x', 'precedes:x', 'conceal:x', 'nbsp:x', 'eol:\\x24',
      \		'eol:\\u21b5', 'eol:\\U000021b5', 'eol:x,space:y'],
      \		['xxx', 'eol:']],
      \ 'matchpairs': [['', '(:)', '(:),<:>'], ['xxx']],
      \ 'mkspellmem': [['10000,100,12'], ['', 'xxx', '10000,100']],
      \ 'mouse': [['', 'n', 'v', 'i', 'c', 'h', 'a', 'r', 'nvi'],
      \		['xxx', 'n,v,i']],
      \ 'mousemodel': [['', 'extend', 'popup', 'popup_setpos'], ['xxx']],
      \ 'mouseshape': [['', 'n:arrow'], ['xxx']],
      \ 'nrformats': [['', 'alpha', 'octal', 'hex', 'bin', 'unsigned', 'blank',
      \		'alpha,hex,bin'],
      \		['xxx']],
      \ 'patchmode': [['', 'xxx', '.x'], [&backupext, '*']],
      \ 'previewpopup': [['', 'height:13', 'width:20', 'highlight:That',
      \		'align:item', 'align:menu', 'border:on', 'border:off',
      \		'width:10,height:234,highlight:Mine'],
      \		['xxx', 'xxx:99', 'height:yes', 'width:no', 'align:xxx',
      \		'border:maybe', 'border:1', 'border:']],
      \ 'printmbfont': [['', 'r:some', 'b:some', 'i:some', 'o:some', 'c:yes',
      \		'c:no', 'a:yes', 'a:no', 'b:Bold,c:yes'],
      \		['xxx', 'xxx,c:yes', 'xxx:', 'xxx:,c:yes']],
      \ 'printoptions': [['', 'header:0', 'left:10pc,top:5pc'],
      \		['xxx', 'header:-1']],
      \ 'scrollopt': [['', 'ver', 'hor', 'jump', 'ver,hor'], ['xxx']],
      \ 'renderoptions': [[''], ['xxx']],
      \ 'rightleftcmd': [['search'], ['xxx']],
      \ 'rulerformat': [['', 'xxx'], ['%-', '%(', '%15(%%']],
      \ 'selection': [['old', 'inclusive', 'exclusive'], ['', 'xxx']],
      \ 'selectmode': [['', 'mouse', 'key', 'cmd', 'key,cmd'], ['xxx']],
      \ 'sessionoptions': [['', 'blank', 'curdir', 'sesdir',
      \		'help,options,slash'],
      \		['xxx', 'curdir,sesdir']],
      \ 'showcmdloc': [['', 'last', 'statusline', 'tabline'], ['xxx']],
      \ 'signcolumn': [['', 'auto', 'no', 'yes', 'number'], ['xxx', 'no,yes']],
      \ 'spellfile': [['', 'file.en.add', 'xxx.en.add,yyy.gb.add,zzz.ja.add',
      \		'/tmp/dir\ with\ space/en.utf-8.add',
      \		'/tmp/dir\\,with\\,comma/en.utf-8.add'],
      \		['xxx', '/tmp/file', '/tmp/dir*with:invalid?char/file.en.add',
      \		',file.en.add', 'xxx,yyy.en.add', 'xxx.en.add,yyy,zzz.ja.add']],
      \ 'spelllang': [['', 'xxx', 'sr@latin'], ['not&lang', "that\\\rthere"]],
      \ 'spelloptions': [['', 'camel'], ['xxx']],
      \ 'spellsuggest': [['', 'best', 'double', 'fast', '100', 'timeout:100',
      \		'timeout:-1', 'file:/tmp/file', 'expr:Func()', 'double,33'],
      \		['xxx', '-1', 'timeout:', 'best,double', 'double,fast']],
      \ 'splitkeep': [['', 'cursor', 'screen', 'topline'], ['xxx']],
      \ 'statusline': [['', 'xxx'], ['%$', '%{', '%{%', '%{%}', '%(', '%)']],
      \ 'swapsync': [['', 'sync', 'fsync'], ['xxx']],
      \ 'switchbuf': [['', 'useopen', 'usetab', 'split', 'vsplit', 'newtab',
      \		'uselast', 'split,newtab'],
      \		['xxx']],
      \ 'tabclose': [['', 'left', 'uselast', 'left,uselast'], ['xxx']],
      \ 'tabline': [['', 'xxx'], ['%$', '%{', '%{%', '%{%}', '%(', '%)']],
      \ 'tagcase': [['followic', 'followscs', 'ignore', 'match', 'smart'],
      \		['', 'xxx', 'smart,match']],
      \ 'termencoding': [has('gui_gtk') ? [] : ['', 'utf-8'], ['xxx']],
      \ 'termwinkey': [['', 'f', '^Y', '^@', '<Esc>', '<t_xx>', "\u3042", '<',
      \		'^'],
      \		['<xxx>', '<t_xxx>', '<Esc', '<t_xx']],
      \ 'termwinsize': [['', '24x80', '0x80', '32x0', '0x0'],
      \		['xxx', '80', '8ax9', '24x80b']],
      \ 'termwintype': [['', 'winpty', 'conpty'], ['xxx']],
      \ 'titlestring': [['', 'xxx', '%('], []],
      \ 'toolbar': [['', 'icons', 'text', 'horiz', 'tooltips', 'icons,text'],
      \		['xxx']],
      \ 'toolbariconsize': [['', 'tiny', 'small', 'medium', 'large', 'huge',
      \		'giant'],
      \		['xxx']],
      \ 'ttymouse': [['', 'xterm'], ['xxx']],
      \ 'varsofttabstop': [['8', '4,8,16,32'], ['xxx', '-1', '4,-1,20', '1,']],
      \ 'vartabstop': [['8', '4,8,16,32'], ['xxx', '-1', '4,-1,20', '1,']],
      \ 'verbosefile': [['', './Xfile'], []],
      \ 'viewoptions': [['', 'cursor', 'folds', 'options', 'localoptions',
      \		'slash', 'unix', 'curdir', 'unix,slash'], ['xxx']],
      \ 'viminfo': [['', '''50', '"30', "'100,<50,s10,h"], ['xxx', 'h']],
      \ 'virtualedit': [['', 'block', 'insert', 'all', 'onemore', 'none',
      \		'NONE', 'all,block'],
      \		['xxx']],
      \ 'whichwrap': [['', 'b', 's', 'h', 'l', '<', '>', '~', '[', ']', 'b,s',
      \		'bs'],
      \		['xxx']],
      \ 'wildmode': [['', 'full', 'longest', 'list', 'lastused', 'list:full',
      \		'full,longest', 'full,full,full,full'],
      \		['xxx', 'a4', 'full,full,full,full,full']],
      \ 'wildoptions': [['', 'tagfile', 'pum', 'fuzzy'], ['xxx']],
      \ 'winaltkeys': [['no', 'yes', 'menu'], ['', 'xxx']],
      \
      "\ skipped options
      \ 'luadll': [[], []],
      \ 'perldll': [[], []],
      \ 'pythondll': [[], []],
      \ 'pythonthreedll': [[], []],
      \ 'pyxversion': [[], []],
      \ 'rubydll': [[], []],
      \ 'tcldll': [[], []],
      \ 'term': [[], []],
      \ 'ttytype': [[], []],
      \
      "\ default behaviours
      \ 'othernum': [[-1, 0, 100], ['']],
      \ 'otherstring': [['', 'xxx'], []],
      \}

const invalid_options = test_values->keys()
      \->filter({-> v:val !~# '^other' && !exists($"&{v:val}")})
if !empty(invalid_options)
  throw $"Invalid option name in test_values: '{invalid_options->join("', '")}'"
endif

1
/struct vimoption options
while 1
  /{"
  if line('.') > end
    break
  endif
  let line = getline('.')
  let name = substitute(line, '.*{"\([^"]*\)".*', '\1', '')
  let shortname = substitute(line, '.*"\([^"]*\)".*', '\1', '')

  if has_key(test_values, name)
    let a = test_values[name]
  elseif line =~ 'P_NUM'
    let a = test_values['othernum']
  else
    let a = test_values['otherstring']
  endif
  if len(a[0]) > 0 || len(a[1]) > 0
    if name == 'browsedir'
      call add(script, 'call mkdir("Xdir with space")')
    endif

    if line =~ 'P_BOOL'
      call add(script, 'set ' . name)
      call add(script, 'set ' . shortname)
      call add(script, 'set no' . name)
      call add(script, 'set no' . shortname)
    else
      for val in a[0]
	call add(script, 'set ' . name . '=' . val)
	call add(script, 'set ' . shortname . '=' . val)
      endfor

      " setting an option can only fail when it's implemented.
      call add(script, "if exists('+" . name . "')")
      for val in a[1]
	call add(script, "silent! call assert_fails('set " . name . "=" . val . "')")
	call add(script, "silent! call assert_fails('set " . shortname . "=" . val . "')")
      endfor
      call add(script, "endif")
    endif

    " cannot change 'termencoding' in GTK
    if name != 'termencoding' || !has('gui_gtk')
      call add(script, 'set ' . name . '&')
      call add(script, 'set ' . shortname . '&')
    endif
    if name == 'browsedir'
      call add(script, 'call delete("Xdir with space", "d")')
    elseif name == 'verbosefile'
      call add(script, 'call delete("Xfile")')
    endif

    if name == 'more'
      call add(script, 'set nomore')
    elseif name == 'lines'
      call add(script, 'let &lines = save_lines')
    endif
  endif
endwhile

call add(script, 'let &columns = save_columns')
call add(script, 'let &lines = save_lines')

call writefile(script, 'opt_test.vim')

" Write error messages if error occurs.
catch
  " Append errors to test.log
  let error = $'Error: {v:exception} in {v:throwpoint}'
  echoc error
  split test.log
  call append('$', error)
  write
endtry

endif

qa!
