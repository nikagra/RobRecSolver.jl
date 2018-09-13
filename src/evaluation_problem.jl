"""
    evaluationProblem(C, c, d, Γ, α, x, X)

Compute EVAL(x) with accuracy ϵ.
"""
function evaluationProblem(C, c, d, Γ, α, x, X)
    ϵ = getProperty("evaluationProblem.epsilon", parameterType = Float64)
    timeLimit = getProperty("evaluationProblem.timeLimit")

    tic()
    ub = Inf
    c₀ = initialScenario(c, d, Γ)
    (y, lb) = incrementalProblem(c₀, α, x, X)
    Y = [y]
    Δt = toq()
    while (ub - lb)/lb > ϵ && Δt <= timeLimit
        tic()
        (c̃, t̃) = relaxedAdversarialProblem(c, d, Γ, Y)
        ub = t̃
        (y, nlb) = incrementalProblem(c̃, α, x, X)
        if lb < nlb
            lb = nlb
        end
        push!(Y, y)
        Δt += toq()
    end
    vecdot(C, x) + ub
end

function relaxedAdversarialProblem(c, d, Γ, Y)
    n = size(c, 1)

    model = Model(solver=CplexSolver(CPX_PARAM_TILIM = getProperty("evaluationProblem.timeLimit"),
        CPXPARAM_ScreenOutput = getProperty("evaluationProblem.cplexLogging")))

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
