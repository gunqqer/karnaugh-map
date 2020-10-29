# NOTE: THIS FORK IS STILL IN DEVELOPEMENT.
# Cartonaugh
This package is a fork of the [karnaugh-map](https://github.com/2pi/karnaugh-map) package. This fork
is meant to replace some of the functions in this package with Lua internally, and add some 
features unto the original package (for example I'm thinking an auto-boolean equation parser).

## But Why LuaLaTeX?
Personally, it's much easier to write expansion macros in Lua rather than nativally in LaTeX. It's just
a matter of personal preference. It make macros easier to explain, document, and expand upon in the future.
It also allows for some advanced capability, for example the ability to feed in a boolean equation and have it
automatically highlight which cells need to be highlighed (upcomming/todo).

## Installation
    # to get the cartonaugh.sty file
    lualatex cartonaugh.ins
    # to get the documentation: cartonaugh.pdf
    lualatex cartonaugh.dtx

## Dependencies
* tikz
* xparse
* xstring

## Development
This fork is still in development.

## TODOs
- Fully test out package with some functions switched to Lua
- Add a color input function
- Add option to have graphs close together for a 4x4x2 or a 4x4x4 table.
- Add some kind of boolean parser (for example just feeding in (A+B)*C) (Long term)

## Tests
    ./test.sh
Testing consists of building the pdf output from the test files, and then comparing them to how they are expected to look like.
Comparison is done with help from [diff-pdf](https://github.com/vslavik/diff-pdf).
All of this is done by running the `test.sh` file from the project root folder.
If there is a difference, between the actual and expected output, a diff will be written to the folder `test/result`.

## License
As karnaugh-map is licensed under [CC BY-SA](https://creativecommons.org/licenses/by-sa/3.0/), and thus so is this fork. 

## Credit
Credit goes to [2pi](https://github.com/2pi) and [Oscar Gustafsson](https://github.com/oscargus) for writting the orignal package which
this is based upon/forked from.
