"""
    adversarialProblem(C, c, d, Γ, X, α)

Compute ADV(ϵ) with accuracy ϵ.
"""
function adversarialProblem(C, c, d, Γ, X, α)
    ϵ = getProperty("adversarialProblem.epsilon", parameterType = Float64)
    timeLimit = getProperty("adversarialProblem.timeLimit")
    numConstraints = 1

    Δt = @elapsed begin
        c₀ = initialScenario(c, d, Γ)
        (x, y, lb) = recoverableProblem(C, c₀, X, α)

        (model, c̃ᵥ, c̃, t̃ᵥ, t̃) = relaxedAdversarialProblem(C, c, d, Γ, x, y)
        ub = t̃
    end
    while abs(ub - lb)/lb > ϵ && Δt <= timeLimit
        Δt += @elapsed begin

            (x, y, nlb) = recoverableProblem(C, c̃, X, α)
            if lb < nlb
                lb = nlb
            end

            (model, c̃, t̃) = addConstraintAndSolve(model, C, c̃ᵥ, t̃ᵥ, x, y)
            ub = t̃

            numConstraints += 1
        end
    end

    @debug "$(numConstraints) constraints was added to this adversarial problem"

    lb
end

function relaxedAdversarialProblem(C, c, d, Γ, x, y)
    n = size(c, 1)

    model = Model(solver=CplexSolver(CPX_PARAM_TILIM = getProperty("adversarialProblem.timeLimit"),
        CPXPARAM_ScreenOutput = getProperty("adversarialProblem.cplexLogging")))

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

    @constraint(model, t̃ <= vecdot(C, x) + vecdot(c̃, y))

    @constraint(model, c̃ .>= c)
    @constraint(model, c̃ .<= c + d)
    @constraint(model, sum(c̃ - c) <= Γ)

    status = solve(model)
    return (model, c̃, getvalue(c̃), t̃, getvalue(t̃))
end

function addConstraintAndSolve(model, C, c̃, t̃, x, y)
    @constraint(model, t̃ <= vecdot(C, x) + vecdot(c̃, y))

    status = solve(model)

    return (model, getvalue(c̃), getvalue(t̃))
end
