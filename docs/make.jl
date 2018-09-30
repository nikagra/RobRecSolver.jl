using Documenter, RobRecSolver

makedocs(
    modules = [RobRecSolver],
    format = :html,
    sitename = "CSV.jl",
    pages = ["Home" => "index.md"]
)
