"""
    evaluationProblem(C, c, d, Γ, α, x, X)

Compute EVAL(x) with accuracy ϵ.
"""
function evaluationProblem(C, c, d, Γ, α, x, X)
    ub = Inf
    c₀ = initialScenario(c, d, Γ)
    (y, lb) = incrementalProblem(c₀, α, x, X)
    Y = [y]
    while (ub - lb)/lb > 0.01
        (c̃, t̃) = relaxedAdversarialProblem(c, d, Γ, Y)
        ub = t̃
        (y, nlb) = incrementalProblem(c̃, α, x, X)
        if lb < nlb
            lb = nlb
        end
        push!(Y, y)
    end
    vecdot(C, x) + ub
end

function relaxedAdversarialProblem(c, d, Γ, Y)
    n = size(c, 1)

    model = Model(solver=CplexSolver(CPXPARAM_ScreenOutput = 0))
    @variable(model, t̃)
    if ndims(c) == 1
        @variable(model, c̃[1:n])
    elseif ndims(c) == 2
        m = size(c, 2)
        @variable(model, c̃[1:n, 1:m])
    else
        throw(ArgumentError("Unsupported number of dimensions ($(ndims(c)))"))
    end

    @objective(model, Max, t̃)

    @constraint(model, [y in Y], t̃ <= vecdot(c̃, y))

    @constraint(model, c̃ .>= c)
    @constraint(model, c̃ .<= c + d)
    @constraint(model, sum(c̃ - c) <= Γ)

    status = solve(model)
    return (getvalue(c̃), getvalue(t̃))
end
