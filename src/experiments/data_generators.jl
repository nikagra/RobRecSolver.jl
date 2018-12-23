"""
    generateData(problemDescriptor::ProblemDescriptor)

Helper function designed to generate experiment data for each problem under consideration.
It returns a tuple `(C, c, d, Γ, X)` where
1. `C` is a vector of nonnegative first stage costs
2. `c` is a vector of a nonnegative nominal second stage costs
3. `d` is a vector of maximal deviations of the costs from their nominal values
4. `Γ` is a budget, or the amount of uncertainty, which can be allocated to the second stage costs
5. `X` is a set of feasible solutions represented as a list functions, each of which accepts a list of JuMP variables as an argument and returns a JuMP linear constraint
"""
generateData(c::ProblemDescriptor) = error("No generateData method defined for data generator type $(typeof(c))")

function generateData(g::KnapsackProblemDescriptor)
    C = rand(1:20, g.n)
    c = rand(1:20, g.n)
    d = rand(1:100, g.n)
    Γ = floor(Int, 0.1 * sum(d))
    w = rand(1:20, g.n)
    W = floor(Int, 0.3 * sum(w))
    X = getKnapsackConstraints(w, W)
    (C, c, d, Γ, X)
end

function generateData(g::AssignmentProblemDescriptor)
    C = rand(1:20, g.n, g.n)
    c = rand(1:20, g.n, g.n)
    d = rand(1:100, g.n, g.n)
    Γ = floor(Int, 0.1 * sum(d))
    X = getAssignmentConstraints(g.n)
    (C, c, d, Γ, X)
end
