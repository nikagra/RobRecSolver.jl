"""
    evaluationProblem(C, c, d, Γ, α, x, X, pd)

Computes ``\\textsc{Eval}(\\pmb{x})`` with accuracy ϵ.

Check section 4 _Solving the problems by MIP formulations_ of [publication](https://arxiv.org/abs/1811.06719)
for more information about this algorithm.

# Arguments
- `C`: is a vector of nonnegative first stage costs.
- `c`: is a vector of a nonnegative nominal second stage costs.
- `d`: is a vector of maximal deviations of the costs from their nominal values.
- `Γ`: is a budget, or the amount of uncertainty, which can be allocated to the second stage costs.
- `X`: is a set of feasible solutions represented as a list functions, each of which accepts a list of JuMP variables as an argument and returns a JuMP linear constraint.
- `α`: fixed number belonging to ``[0, 1]``
- `pd`: an instance of [`ProblemDescriptor`](@ref)
"""
function evaluationProblem(C, c, d, Γ, α, x, X, pd)
    ϵ = getProperty("evaluationProblem.epsilon", parameterType = Float64)
    timeLimit = getProperty("evaluationProblem.timeLimit")
    numConstraints = 1

    Δt = @elapsed begin
        c₀ = initialScenario(c, d, Γ)
        (y, lb) = incrementalProblem(c₀, α, x, X, pd)

        (model, c̃ᵥ, c̃, t̃ᵥ, t̃) = relaxedAdversarialProblem(c, d, Γ, y)
        ub = t̃
    end
    while abs(ub - lb)/lb > ϵ && Δt <= timeLimit
        Δt += @elapsed begin

            (y, nlb) = incrementalProblem(c̃, α, x, X, pd)
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
