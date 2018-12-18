abstract type ProblemDescriptor end

getProblemSize(c::ProblemDescriptor) = c.n
getSaneComputationLimit(c::ProblemDescriptor) = c.saneComputationLimit

hasEqualCardinalityProperty(c::ProblemDescriptor) = c.equalCardinalityProperty
getCardinality(c::ProblemDescriptor) = c.cardinality

struct KnapsackProblemDescriptor <: ProblemDescriptor
    equalCardinalityProperty::Bool
    cardinality::Int
    n::Int
    saneComputationLimit::Int

    KnapsackProblemDescriptor(n::Integer) = new(false, -1, n, 400)
end

struct AssignmentProblemDescriptor <: ProblemDescriptor
    equalCardinalityProperty::Bool
    cardinality::Int
    n::Int
    saneComputationLimit::Int

    AssignmentProblemDescriptor(n::Integer) = new(true, n, n, 25)
end
