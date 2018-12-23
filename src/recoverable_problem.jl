"""
    recoverableProblem(C, c, X, α, dg)

Solves recoverable problem ``REC(c) = min_{x \\in X} min_{y \\in X^{\\alpha}_x} (Cx + cy)``. 

Check section 4 _Solving the problems by MIP formulations_ of [publication](https://arxiv.org/abs/1811.06719)
for more information about this algorithm.

# Arguments
- `C`: is a vector of nonnegative first stage costs.
- `c`: is a vector of a nonnegative nominal second stage costs.
- `X`: is a set of feasible solutions represented as a list functions, each of which
    accepts a list of JuMP variables as an argument and returns a JuMP linear constraint.
- `α`: fixed number belonging to ``[0, 1]``
- `pd`: instance of [`ProblemDescriptor`](@ref)
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
