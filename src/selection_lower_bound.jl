"""
    selectionLowerBound(C, c, d, Γ, X, α, dg)

Computes selection lower bound.

Check section 5.2 _Selection lower bound_ of [publication](https://arxiv.org/abs/1811.06719)
for more information about this algorithm.

# Arguments
- `C`: is a vector of nonnegative first stage costs.
- `c`: is a vector of a nonnegative nominal second stage costs.
- `d`: is a vector of maximal deviations of the costs from their nominal values.
- `Γ`: is a budget, or the amount of uncertainty, which can be allocated to the second stage costs.
- `X`: is a set of feasible solutions represented as a list functions, each of which
    accepts a list of JuMP variables as an argument and returns a JuMP linear constraint.
- `α`: fixed number belonging to ``[0, 1]``
- `pd`: instance of [`ProblemDescriptor`](@ref)
"""
function selectionLowerBound(C, c, d, Γ, X, α, dg)
    @assert size(C) == size(c) == size(d)

    n = size(C, 1)

    model = Model(solver = CplexSolver(CPX_PARAM_TILIM = getProperty("selectionLowerBound.timeLimit"),
        CPXPARAM_ScreenOutput = getProperty("selectionLowerBound.cplexLogging")))

    @variable(model, π >= 0)
    if ndims(c) == 1
        @variable(model, x[1:n], Bin)
        @variable(model, 0 <= y[1:n] <= 1)
        @variable(model, u[1:n] >= 0)
        @variable(model, z[1:n] >= 0)
    elseif ndims(c) == 2
        m = size(c, 2)
        @variable(model, x[1:n, 1:m], Bin)
        @variable(model, 0 <= y[1:n, 1:m] <= 1)
        @variable(model, u[1:n, 1:m] >= 0)
        @variable(model, z[1:n, 1:m] >= 0)
    else
        throw(ArgumentError("Unsupported number of dimensions ($(ndims(c)))"))
    end

    @objective(model, Min, vecdot(C, x) + π * Γ + vecdot(c, y) + vecdot(u, d))

    # Linearization of dot(x, y) >= (1 - α) sum(x)
    @constraint(model, z .<= x)
    @constraint(model, z .<= y)
    @constraint(model, -y + π + u .>= 0)

    if hasEqualCardinalityProperty(dg)
        cardinality = getCardinality(dg)
        k = ceil(cardinality * (1 - α))
        @constraint(model, sum(z) >= k)
        @constraint(model, sum(y) == cardinality)
    else
        @constraint(model, sum(z) >= (1 - α) * sum(x))
    end

    # Constraints defining set of feasible solutions
    for constraint in X
        JuMP.addconstraint(model, constraint(x))
    end

    status = solve(model)
    if status == :Optimal
        return getobjectivevalue(model)
    else
        return getobjectivebound(model)
    end
end
