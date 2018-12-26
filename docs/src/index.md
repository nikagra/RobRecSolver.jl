# RobRecSolver.jl

[RobRecSolver](https://github.com/nikagra/RobRecSolver.jl) is a package written in a Julia programming language developed
to test performance of algorithms proposed in _Robust recoverable 0-1 optimization
problems under polyhedral uncertainty_ (Mikita Hradovich, Adam Kasperski, Pawel Zielinski)
which is available as preprint on [arxiv.org](https://arxiv.org/abs/1811.06719).
This work will later be referenced as _publication_.

## Installing RobRecSolver
If you are familiar with Julia you can quickly install RobRecSolver and CPLEX:
```julia-repl
julia> Pkg.add("CPLEX")
julia> Pkg.clone("https://github.com/nikagra/RobRecSolver.jl.git")
```

**Note:** You need a working installation of CPLEX Optimizer. See [Getting CPLEX Optimizer](@ref)
for more information.

## Contents

```@contents
Pages = ["installation.md", "apireference.md", "experiments.md"]
Depth = 3
```

## Citing
You can cite the _publication_ by using the following BibTeX snippet:
```
@article{hradovich2018robust,
  title={Robust recoverable 0-1 optimization problems under polyhedral uncertainty},
  author={Hradovich, Mikita and Kasperski, Adam and Zielinski, Pawel},
  journal={arXiv preprint arXiv:1811.06719},
  year={2018}
}
```
