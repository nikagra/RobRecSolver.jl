using Documenter, RobRecSolver, RobRecSolver.Experiments

makedocs(
    sitename = "RobRecSolver",
    modules = [RobRecSolver, RobRecSolver.Experiments],
    authors = "Mikita Hradovich",
    pages = [
        "Introduction" => "index.md",
        "Installation Guide" => "installation.md",
        "Reference" => "apireference.md",
        "Experiments" => "experiments.md"
    ]
)

deploydocs(
    deps   = Deps.pip("mkdocs", "python-markdown-math"),
    repo = "github.com/nikagra/RobRecSolver.jl.git",
    julia = "0.6",
    osname = "linux"
)
