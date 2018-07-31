# RobRecSolver

[![Build Status](https://travis-ci.org/nikagra/RobRecSolver.jl.svg?branch=master)](https://travis-ci.org/nikagra/RobRecSolver.jl)

[![Coverage Status](https://coveralls.io/repos/nikagra/RobRecSolver.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/nikagra/RobRecSolver.jl?branch=master)

[![codecov.io](http://codecov.io/github/nikagra/RobRecSolver.jl/coverage.svg?branch=master)](http://codecov.io/github/nikagra/RobRecSolver.jl?branch=master)

## Installation
The package can be installed with `Pkg.clone`:
```julia-repl
julia> Pkg.clone("git://github.com/nikagra/RobRecSolver.jl.git")
```

## Usage
Run the following commands Julia REPL to run experiments:
```julia-repl
julia> import RobRecSolver
julia> RobRecSolver.runExperiment([100, 400, 1000], RobRecSolver.generateKnapsackData)
```

## Documentation
The package uses `Documenter.jl` to generate documentation. Run the following command from the `docs/` directory:
```bash
$ julia make.jl
```

## Unit Tests
To run unit tests run the following command in Julia REPL:
```julia-repl
julia> Pkg.test("RobRecSolver")
```
