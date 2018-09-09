abstract type DataGenerator end

generateData(c::DataGenerator) = error("No generateData method defined for data generator type $(typeof(c))")
hasEqualCardinalityProperty(c::DataGenerator) = c.equalCardinalityProperty

struct KnapsackDataGenerator <: DataGenerator
    equalCardinalityProperty::Bool
    n::Integer

    KnapsackDataGenerator(n::Integer) = new(false, n)
end

function generateData(g::KnapsackDataGenerator)
    C = rand(1:20, g.n)
    c = rand(1:20, g.n)
    d = rand(1:100, g.n)
    Γ = floor(Int, 0.1 * sum(d))
    w = rand(1:20, g.n)
    W = floor(Int, 0.3 * sum(w))
    X = getKnapsackConstraints(w, W)
    (C, c, d, Γ, X)
end

struct AssignmentDataGenerator <: DataGenerator
    equalCardinalityProperty::Bool
    m::Integer

    AssignmentDataGenerator(m::Integer) = new(true, m)
end

function generateData(g::AssignmentDataGenerator)
    C = rand(1:20, g.m, g.m)
    c = rand(1:20, g.m, g.m)
    d = rand(1:100, g.m, g.m)
    Γ = floor(Int, 0.1 * sum(d))
    X = getAssignmentConstraints(g.m)
    (C, c, d, Γ, X)
end
