# Installation Guide
This guide will briefly guide you through installing Julia, CPLEX Optimizer
and RobRecSolver with all of its dependencies.

## Getting Julia
Version of Julia required by JuMP and consequently by RobRecSolver is `0.6`. You
can build Julia from source or use the binaries.

Download links and more detailed instructions are available on the Julia website.

## Getting CPLEX Optimizer
RobRecSolver package depends on [CPLEX.jl](https://github.com/JuliaOpt/CPLEX.jl)
which in turn requires a working installation of [CPLEX Optimizer](https://www.ibm.com/analytics/cplex-optimizer)
with a license, which is free for faculty members and graduate teaching assistants.

CPLEX Optimizer must be downloaded and installed separately. Check [CPLEX.jl](https://github.com/JuliaOpt/CPLEX.jl)
for further instructions.

## Getting RobRecSolver
RobRecSolver package is _not_ yet registered in the [METADATA.jl](https://github.com/JuliaLang/METADATA.jl) repository. To install it,
use `Pkg.clone` command:
```julia-repl
julia> Pkg.clone("https://github.com/nikagra/RobRecSolver.jl.git")
```

Since RobRecSolver contains REQUIRE file, that file will be used to determine which
registered packages RobRecSolver depends on, and they will be automatically installed.

## Updating RobRecSolver
In order to update package run the following sequence of commands (`;` symbol
at the start of the Julia's REPL enters shell mode):
```julia-repl
julia> cd(Pkg.dir("RobRecSolver"))
julia> ;
shell> git fetch --all --tags --prune && git checkout tags/<version>
julia> Pkg.resolve()
```
