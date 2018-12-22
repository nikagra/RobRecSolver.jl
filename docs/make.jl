using Documenter, RobRecSolver, RobRecSolver.Experiments

makedocs(
    modules = [RobRecSolver, RobRecSolver.Experiments]
)

deploydocs(
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/nikagra/RobRecSolver.jl.git",
    julia = "0.6",
    osname = "linux"
)
