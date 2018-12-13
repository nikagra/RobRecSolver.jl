using Documenter, RobRecSolver

makedocs(
    modules = [RobRecSolver]
)

deploydocs(
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/nikagra/RobRecSolver.jl.git",
    julia = "0.6"
)
