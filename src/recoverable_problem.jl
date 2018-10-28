"""
    recoverableProblem(C, c, X, α, dg)

Mathematical programming model for solving the following recoverable problem:
    ``REC(c) = min_{x \\in X} min_{y \\in X^{\\alpha}_x} (Cx + cy)``
"""
function recoverableProblem(C, c, X, α, dg)
    @assert size(C) == size(c)

    n = size(C, 1)

    model = Model(solver=CplexSolver(CPXPARAM_ScreenOutput = getProperty("recoverableProblem.cplexLogging")))
    if ndims(C) == 1
        @variable(model, x[1:n], Bin)
        @variable(model, y[1:n], Bin)
        if hasEqualCardinalityProperty(dg)
            @variable(model, z[1:n] >= 0)
        else
            @variable(model, z[1:n], Bin)
        end
    elseif ndims(C) == 2
        m = size(C, 2)
        @variable(model, x[1:n, 1:m], Bin)
        @variable(model, y[1:n, 1:m], Bin)
        if hasEqualCardinalityProperty(dg)
            @variable(model, z[1:n, 1:m] >= 0)
        else
            @variable(model, z[1:n, 1:m], Bin)
        end
    else
        throw(ArgumentError("Unsupported number of dimensions ($(ndims(C)))"))
    end

    @objective(model, Min, vecdot(C, x) + vecdot(c, y))

    if hasEqualCardinalityProperty(dg)
        l = ceil(n * (1 - α))
        @constraint(model, sum(z) >= l)
    else
        @constraint(model, sum(x-z) <= α * sum(x))
        @constraint(model, z .>= x + y - 1)
    end

    @constraint(model, z .<= x)
    @constraint(model, z .<= y)

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
