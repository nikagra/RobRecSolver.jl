"""
    adversarialProblem(C, c, d, Γ, X, α)

Compute ADV(ϵ) with accuracy ϵ.
"""
function adversarialProblem(C, c, d, Γ, X, α)
    tic()
    ub = Inf
    c₀ = initialScenario(c, d, Γ)
    (x, y, lb) = recoverableProblem(C, c₀, X, α)
    Z = [(x, y)]
    Δt = toq()
    while (ub - lb)/lb > 0.01 && Δt <= 600
        tic()
        (c, t) = relaxedAdversarialProblem(C, c, d, Γ, Z)
        ub = t
        (x, y, nlb) = recoverableProblem(C, c, X, α)
        if lb < nlb
            lb = nlb
        end
        push!(Z, (x, y))
        Δt += toq()
    end
    lb
end

function relaxedAdversarialProblem(C, c, d, Γ, Z)
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

    @constraint(model, [(x, y) in Z], t̃ <= vecdot(C, x) + vecdot(c̃, y))

    @constraint(model, c̃ .>= c)
    @constraint(model, c̃ .<= c + d)
    @constraint(model, sum(c̃ - c) <= Γ)

    status = solve(model)
    return (getvalue(c̃), getvalue(t̃))
end
