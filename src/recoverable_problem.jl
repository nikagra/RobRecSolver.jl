"""
    recoverableProblem(C, c, α, X)

Mathematical programming model for solving the following recoverable problem:
    ``REC(c) = min_{x \\in X} min_{y \\in X^{\\alpha}_x} (Cx + cy)``
"""
function recoverableProblem(C, c, α, X)
    @assert size(C) == size(c)

    n = size(C, 1)

    model = Model(solver=CbcSolver())
    if ndims(C) == 1
        @variable(model, x[1:n], Bin)
        @variable(model, y[1:n], Bin)
        @variable(model, z[1:n], Bin)
    elseif ndims(C) == 2
        m = size(C, 2)
        @variable(model, x[1:n, 1:m], Bin)
        @variable(model, y[1:n, 1:m], Bin)
        @variable(model, z[1:n, 1:m], Bin)
    else
        throw(ArgumentError("Unsupported number of dimensions ($(ndims(C)))"))
    end

    @objective(model, Min, vecdot(C, x) + vecdot(c, y))

    @constraint(model, sum(x-z) <= α * sum(x))

    @constraint(model, z .<= x)
    @constraint(model, z .<= y)
    @constraint(model, z .>= x + y - 1)

    # Constraints defining set of feasible solutions
    for constraint in X
        JuMP.addconstraint(model, constraint(x))
    end

    for constraint in X
        JuMP.addconstraint(model, constraint(y))
    end

    status = solve(model)
    (getvalue(x), getvalue(y), getobjectivevalue(model))
end
