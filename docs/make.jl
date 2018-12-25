using Documenter, RobRecSolver, RobRecSolver.Experiments

makedocs(
    modules = [
        RobRecSolver,
        RobRecSolver.Experiments
    ]
)
run(`mkdocs build`)
