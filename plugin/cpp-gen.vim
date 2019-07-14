" Check whether a block encloses a certain line
function ScopeEncloses(targetLine)
	let currentLine = line(".")
	let savepos = getpos(".")
	" Test if class was only prototyped
	call search(";")
	if currentLine == line(".")
		return 0
	endif

	call setpos(".", savepos)

	let start = search("{")
	normal! %
	let end = line(".")

	call setpos(".", savepos)
	"heck
	"heck
	if a:targetLine >= start && a:targetLine <= end
		return 1
	endif

endfunction

" Construct a definition using focused declaration
function GetDef()
	set iskeyword+=~

	let savepos = getpos(".")

	" Find args
	normal! $F)%l
	normal! "ayi(
	let args = @a

	" Find name
	normal! $F)%b"ayw
	let name = @a

	" Find prefix
	normal! hv0"ay
	let prefix = trim(@a)
	if len(prefix) > 0
		let prefix = prefix . " "
	endif

	" Find class name
	let targetLine = line(".")
	let classNames = ""
	while 1
		let classLine = search("class", "bW")
		if classLine == 0
			break
		endif

		normal! w"ayw
		normal! b
		let className = @a
		if ScopeEncloses(targetLine)
			" Add to class name
			let classNames = className . "::" . classNames
		endif
	endwhile



	let generated = prefix . classNames . name . "(" . args . ")\n{\n}"
	call setpos(".", savepos)

	return generated

endfunction

" Generate a definition in source file
function GenDef()
	let headerName = @%
	let sourceName = expand('%:t:r') . ".cpp"
	if bufexists(sourceName) <= 0
		echo "Source file not loaded: " . sourceName
	else
		" Get the generated code
		let generated = GetDef()

		" Switch to source buffer
		set switchbuf +=useopen
		execute "sbuffer " . sourceName

		" Write generated code to source buffer
		execute "normal! Go\n" . generated

		" Switch back
		execute "sbuffer " . headerName
	endif

endfunction

" Goto a definition in source file
function GotoDef()
	let headerName = @%
	let sourceName = expand('%:t:r') . ".cpp"
	if bufexists(sourceName) <= 0
		echo "Source file not loaded: " . sourceName
	else
		" Get the generated code (escape ~ cuz yea)
		let generated = escape(GetDef(), '~*/.[]')

		" Switch to source buffer
		set switchbuf +=useopen
		execute "sbuffer " . sourceName

		" Search for code (just the first line of it)
		let found = search(split(generated, '\n')[0])
		if found <= 0
			echo "Definition could not be found. /:"
			" Switch back
			execute "sbuffer " . headerName
		endif
	endif

endfunction
