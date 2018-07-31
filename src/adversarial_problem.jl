"""
    adversarialProblem(C, c, d, Γ, α, x, X)

Compute ADV(x) with accuracy ϵ.
"""
function adversarialProblem(C, c, d, Γ, α, x, X)
    ub = Inf
    c₀ = initialScenario(c, d, Γ)
    (x, y, lb) = recoverableProblem(C, c₀, α, X)
    Z = [(x, y)]
    while (ub - lb)/lb > 0.01
        (c, t) = relaxedAdversarialProblem(C, c, d, Γ, Z)
        ub = t
        (x, y, nlb) = recoverableProblem(C, c, α, X)
        if lb < nlb
            lb = nlb
        end
        push!(Z, (x, y))
    end
    lb
end

function relaxedAdversarialProblem(C, c, d, Γ, Z)
    n = size(c, 1)

    model = Model(solver=CbcSolver())

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
