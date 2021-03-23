# <img src="https://cdn.jsdelivr.net/gh/naveen521kk/au-packages/icons/nim.png" width="48" height="48"/> Nim

Nim is a statically typed compiled systems programming language. It combines successful concepts from mature languages like Python, Ada and Modula.

## Efficient
- Nim generates native dependency-free executables, not dependent on a virtual machine, which are small and allow easy redistribution.
- The Nim compiler and the generated executables support all major platforms like Windows, Linux, BSD and macOS.
- Nim's memory management is deterministic and customizable with destructors and move semantics, inspired by C++ and Rust. It is well-suited for embedded, hard-realtime systems.
- Modern concepts like zero-overhead iterators and compile-time evaluation of user-defined functions, in combination with the preference of value-based datatypes allocated on the stack, lead to extremely performant code.
- Support for various backends: it compiles to C, C++ or JavaScript so that Nim can be used for all backend and frontend needs.

## Expressive
- Nim is self-contained: the compiler and the standard library are implemented in Nim.
- Nim has a powerful macro system which allows direct manipulation of the AST, offering nearly unlimited opportunities.

## Elegant
- Macros cannot change Nim's syntax because there is no need for it — the syntax is flexible enough.
- Modern type system with local type inference, tuples, generics and sum types.
- Statements are grouped by indentation but can span multiple lines.

## Notes
- By default this package install's Nim along with MingW compiler and added to `PATH`.
- You can disable by passing a parameter. See [here](#package-specific)

# Package Specific
## Package Parameters

The following package parameters can be set:
- `/AddToPath:` - Add the binaries to `PATH`. Allowed values are either `true` or `false`. By default `true`. 
- `/InstallGCC:` - Install MingW GCC compiler. Allowed values are either `true` or `false`. by default `true`. 

To pass parameters, use `--params "''"` (e.g. `choco install nim [other options] --params="'/InstallGCC:false'"`).

To have choco remember parameters on upgrade, be sure to set `choco feature enable -n=useRememberedArgumentsForUpgrades`.