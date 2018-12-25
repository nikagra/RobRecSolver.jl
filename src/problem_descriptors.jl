"""
Base type for all problem descriptors. It is expected to has the following fields:
- `n`: the size of the problem.
- `saneComputationLimit`: maximum size of the problem for which computing results for
    adversarial lower bound, recoverable lower bound, selection lower bound or
    lagrangian lower bound makes sense.
- `equalCardinalityProperty`: specifies if problem possess equal cardinality property.
- `cardinality`: cardinality of the problem if any.
"""
abstract type ProblemDescriptor end

"""
    getProblemSize(pd::ProblemDescriptor)

Returns the size of the problem.

# Arguments
- `pd`: an instance of [`ProblemDescriptor`](@ref)
"""
getProblemSize(pd::ProblemDescriptor) = pd.n

"""
    getSaneComputationLimit(pd::ProblemDescriptor)

Returns maximum size of the problem for which computing results for adversarial
lower bound, recoverable lower bound, selection lower bound or lagrangian lower bound makes sense.

# Arguments
- `pd`: an instance of [`ProblemDescriptor`](@ref)
"""
getSaneComputationLimit(pd::ProblemDescriptor) = pd.saneComputationLimit

"""
    hasEqualCardinalityProperty(pd::ProblemDescriptor)

Returns whether the problem possess equal cardinality property.

# Arguments
- `pd`: an instance of [`ProblemDescriptor`](@ref)
"""
hasEqualCardinalityProperty(pd::ProblemDescriptor) = pd.equalCardinalityProperty

"""
    getCardinality(pd::ProblemDescriptor)

Returns cardinality of the problem if any.

# Arguments
- `pd`: an instance of [`ProblemDescriptor`](@ref)
"""
getCardinality(pd::ProblemDescriptor) = pd.cardinality

"""
`KnapsackProblemDescriptor` is an implementation [`ProblemDescriptor`](@ref) for
minimum knapsack problem.
"""
struct KnapsackProblemDescriptor <: ProblemDescriptor
    equalCardinalityProperty::Bool
    cardinality::Int
    n::Int
    saneComputationLimit::Int

    KnapsackProblemDescriptor(n::Integer) = new(false, -1, n, 400)
end

"""
`AssignmentProblemDescriptor` is an implementation [`ProblemDescriptor`](@ref) for
minimum assignment problem.
"""
struct AssignmentProblemDescriptor <: ProblemDescriptor
    equalCardinalityProperty::Bool
    cardinality::Int
    n::Int
    saneComputationLimit::Int

    AssignmentProblemDescriptor(n::Integer) = new(true, n, n, 25)
end
