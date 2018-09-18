"""
    adversarialProblem(C, c, d, Γ, X, α)

Compute ADV(ϵ) with accuracy ϵ.
"""
function adversarialProblem(C, c, d, Γ, X, α)
    ϵ = getProperty("adversarialProblem.epsilon", parameterType = Float64)
    timeLimit = getProperty("adversarialProblem.timeLimit")

    Δt = @elapsed begin
        ub = Inf
        c₀ = initialScenario(c, d, Γ)
        (x, y, lb) = recoverableProblem(C, c₀, X, α)
        Z = [(x, y)]
    end
    while (ub - lb)/lb > ϵ && Δt <= timeLimit
        Δt += @elapsed begin
            (c̃, t̃) = relaxedAdversarialProblem(C, c, d, Γ, Z)

            ub = t̃
            (x, y, nlb) = recoverableProblem(C, c̃, X, α)
            if lb < nlb
                lb = nlb
            end
            push!(Z, (x, y))
        end
    end

    @debug "$(size(Z, 1)) constraints was added to this adversarial problem"

    lb
end

function relaxedAdversarialProblem(C, c, d, Γ, Z)
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

    @constraint(model, [(x, y) in Z], t̃ <= vecdot(C, x) + vecdot(c̃, y))

    @constraint(model, c̃ .>= c)
    @constraint(model, c̃ .<= c + d)
    @constraint(model, sum(c̃ - c) <= Γ)

    status = solve(model)
    return (getvalue(c̃), getvalue(t̃))
end
