"""
    incrementalProblem(c, α, x, X, pd)

Solve incremental problem with specified costs `c`, parameter ``α \\in [0, 1]``,
first stage solutions `x` and a list of constraints `X` defining a set of feasible solutions.
"""
function incrementalProblem(c, α, x, X, pd)
    n = size(c, 1)

    model = Model(solver=CplexSolver(CPXPARAM_ScreenOutput = getProperty("incrementalProblem.cplexLogging")))
    if ndims(c) == 1
        @variable(model, y[1:n], Bin)
        if hasEqualCardinalityProperty(pd)
            @variable(model, z[1:n], Bin)
        end
    elseif ndims(c) == 2
        m = size(c, 2)
        @variable(model, y[1:n, 1:m], Bin)
        if hasEqualCardinalityProperty(pd)
            @variable(model, z[1:n, 1:m], Bin)
        end
    else
        throw(ArgumentError("Unsupported number of dimensions ($(ndims(c)))"))
    end

    @objective(model, Min, vecdot(c, y))

    if hasEqualCardinalityProperty(pd)
        k = ceil(n * (1 - α))
        @constraint(model, sum(z) >= k)
        @constraint(model, z .<= y)
        @constraint(model, z .<= x)
    else
        @constraint(model, vecdot(x, 1 - y) <= α * sum(x))
    end

    # Constraints defining set of feasible solutions
    for constraint in X
        JuMP.addconstraint(model, constraint(y))
    end

    status = solve(model)
    return (getvalue(y), getobjectivevalue(model)) # InexactError is thrown here while solving computeAdversarialLowerBound -> evaluationProblem
end
