"""
    selectionLowerBound(C, c, d, Γ, X, α)
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
