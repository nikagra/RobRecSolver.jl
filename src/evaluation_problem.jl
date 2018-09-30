"""
    evaluationProblem(C, c, d, Γ, α, x, X)

Computes EVAL(x) with accuracy ϵ.
"""
function evaluationProblem(C, c, d, Γ, α, x, X)
    ϵ = getProperty("evaluationProblem.epsilon", parameterType = Float64)
    timeLimit = getProperty("evaluationProblem.timeLimit")
    numConstraints = 1

    Δt = @elapsed begin
        c₀ = initialScenario(c, d, Γ)
        (y, lb) = incrementalProblem(c₀, α, x, X)

        (model, c̃ᵥ, c̃, t̃ᵥ, t̃) = relaxedAdversarialProblem(c, d, Γ, y)
        ub = t̃
    end
    while abs(ub - lb)/lb > ϵ && Δt <= timeLimit
        Δt += @elapsed begin

            (y, nlb) = incrementalProblem(c̃, α, x, X)
            if lb < nlb
                lb = nlb
            end

            (model, c̃, t̃) = addConstraintAndSolve(model, c̃ᵥ, t̃ᵥ, y)
            ub = t̃

            numConstraints += 1
        end
    end

    @debug "$(numConstraints) constraints was added to this evaluation problem"

    vecdot(C, x) + ub
end

function relaxedAdversarialProblem(c, d, Γ, y)
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

    @constraint(model, t̃ <= vecdot(c̃, y))

    @constraint(model, c̃ .>= c)
    @constraint(model, c̃ .<= c + d)
    @constraint(model, sum(c̃ - c) <= Γ)

    status = solve(model)
    return (model, c̃, getvalue(c̃), t̃, getvalue(t̃))
end

function addConstraintAndSolve(model, c̃, t̃, y)
    @constraint(model, t̃ <= vecdot(c̃, y))

    status = solve(model)

    return (model, getvalue(c̃), getvalue(t̃))
end
