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
