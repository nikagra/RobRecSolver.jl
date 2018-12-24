# RobRecSolver

[![Build Status](https://travis-ci.org/nikagra/RobRecSolver.jl.svg?branch=master)](https://travis-ci.org/nikagra/RobRecSolver.jl)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://nikagra.github.io/RobRecSolver.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://nikagra.github.io/RobRecSolver.jl/latest)

## Installation
The package can be installed with `Pkg.clone`:
```julia-repl
julia> Pkg.clone("https://github.com/nikagra/RobRecSolver.jl.git")
```
**Note:** This package depends on CPLEX. CPLEX must be downloaded and installed separately. Check [CPLEX.jl](https://github.com/JuliaOpt/CPLEX.jl) for further instructions.

## Usage
Run the following commands Julia REPL to run experiments:
```julia-repl
julia> using RobRecSolver.Experiments
julia> runExperiments([100, 400, 1000], [10, 25, 100])
```

## Documentation
Documentation is available here:
- [**STABLE**](https://nikagra.github.io/RobRecSolver.jl/stable) &mdash; **documentation of the most recently tagged version.**
- [**DEVEL**](https://nikagra.github.io/RobRecSolver.jl/latest) &mdash; *documentation of the in-development version.*

The package uses `Documenter.jl` to generate documentation. To generate documentation manually run the following command from the `docs/` directory:
```bash
$ julia make.jl
```

## Unit Tests
To run unit tests run the following command in Julia REPL:
```julia-repl
julia> Pkg.test("RobRecSolver")
```
