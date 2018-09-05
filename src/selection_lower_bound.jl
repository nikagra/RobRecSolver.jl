"""
    selectionLowerBound(C, c, d, Γ, X, α)
"""
function selectionLowerBound(C, c, d, Γ, X, α)
    @assert size(C) == size(c) == size(d)

    M = typemax(Int)
    n = size(C, 1)

    model = Model(solver = CplexSolver(CPX_PARAM_TILIM = 240, CPXPARAM_ScreenOutput = 0))

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
    @constraint(model, z .<= M * x)
    @constraint(model, z .<= y)
    @constraint(model, z .>= y - (1 - x) * M)
    @constraint(model, sum(z) >= (1 - α) * sum(x))

    @constraint(model, -y + π + u .>= 0)

    # Constraints defining set of feasible solutions
    for constraint in X
        JuMP.addconstraint(model, constraint(x)) # check this
    end

    status = solve(model)
    getobjectivevalue(model)
end
