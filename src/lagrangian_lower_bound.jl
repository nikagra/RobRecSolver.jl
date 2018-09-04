"""
    lagrangian_lower_bound(C, c, d, Γ, X, l)
"""
function lagrangianLowerBound(C, c, d, Γ, X, l)
    ϵ = 1e-2
    ϕ = (1 + sqrt(5)) / 2

    α = 0
    β = l # TODO: check this assumption

    γ = β - (β - α) / ϕ
    δ = α + (β - α) / ϕ
    while abs(γ - δ) > ϵ
        fγ = relaxedIncrementalProblem(C, c, d, Γ, X, γ, l)
        fδ = relaxedIncrementalProblem(C, c, d, Γ, X, δ, l)

        if (fγ < fδ)
            β = δ
        else
            α = γ
        end

        # To avoid loss of precision
        γ = β - (β - α) / ϕ
        δ = α + (β - α) / ϕ
    end

    μ = (β + α) / 2
    relaxedIncrementalProblem(C, c, d, Γ, X, μ, l)
end

function relaxedIncrementalProblem(C, c, d, Γ, X, μ, l)
    @assert size(C) == size(c) == size(d)

    n = size(C, 1)

    model = Model(solver = CbcSolver())

    @variable(model, π >= 0)
    if ndims(C) == 1
        @variable(model, x[1:n], Bin)
        @variable(model, 0 <= y[1:n] <= 1)
        @variable(model, u[1:n] >= 0)
        @variable(model, z[1:n] >= 0)
    elseif ndims(C) == 2
        m = size(C, 2)
        @variable(model, x[1:n, 1:m], Bin)
        @variable(model, 0 <= y[1:n, 1:m] <= 1)
        @variable(model, u[1:n, 1:m] >= 0)
        @variable(model, z[1:n, 1:m] >= 0)
    else
        throw(ArgumentError("Unsupported number of dimensions ($(ndims(c)))"))
    end

    @objective(model, Min, vecdot(C, x) + π * Γ + vecdot(y, c) - μ * sum(z) + vecdot(u, d) + μ * l)

    # Constraints defining set of feasible solutions
    for constraint in X
        JuMP.addconstraint(model, constraint(x)) # Assuming X = {Ax=b, x∈{0, 1}ⁿ}
    end

    @constraint(model, -y + π + u .>= 0)

    # Constraints defining set of feasible solutions
    for constraint in X
        JuMP.addconstraint(model, constraint(y)) # Assuming X = {Ax=b, x∈{0, 1}ⁿ}
    end

    @constraint(model, z .<= x)
    @constraint(model, z .<= y)

    status = solve(model)
    getobjectivevalue(model)
end
