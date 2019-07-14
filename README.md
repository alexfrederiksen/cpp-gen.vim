To be honest, I just wanted a really simple plugin that could parse C++ header files and generate definitions. However all I could find were huge plugins with various dependencies and countless features that I don't quite need in my life right now. So essentially, this plugin fills that shoe in that it doesn't have any dependencies and it does what you expect. Nothing more, nothing less.

## Installation
Installing is fairly easy. You can use Pathogen or just the native vim package manager i.e. just put this project in ~/.vim/pack/<whatever-name-you-like>/start. I personally put it in the "opt" directory rather than "start" so that I can load the plugin manually with `packadd` just for C++ files, because "start" will actually load it for all file types.

## Usage
Basically there are just two functions:

	`GenDef()`
	`GotoDef()`

Simply move to a prototype in your header file that you would like to generate a corresponding definition for and call `GenDef()`. This will attempt to switch to your .cpp buffer and append the definition. The same goes for `GotoDef()` except it will only navigate to the definition.

To map these functions to something more reasonable, I use:
`nmap ,l :call GenDef()<CR>`
`nmap ,g :call GotoDef()<CR>`

If you have any issues, feel free to throw it any the issues tab or submit a pull request. The parsing logic could very well be biased to my own coding style so I'm expecting problems. Also I'm very new to writing vim plugins... so there's that. Enjoy. (;
