"""
    lagrangian_lower_bound(C, c, d, Γ, X, l, dg)

Computes Lagrangian lower bound.
"""
function lagrangianLowerBound(C, c, d, Γ, X, l, dg)
    @assert hasEqualCardinalityProperty(dg)

    tₗ = getProperty("lagrangianLowerBound.timeLimit", parameterType = Int)

    Δt = @elapsed begin
        ϵ = getProperty("lagrangianLowerBound.epsilon", parameterType = Float64)
        invϕ = (sqrt(5) - 1) / 2 # 1/ϕ
        invϕ² = (3 - sqrt(5)) / 2 # 1/ϕ²

        α = 0
        β = 100 # TODO: check this assumption

        h = β - α

        γ = α + invϕ² * h
        fγ, status = relaxedIncrementalProblem(C, c, d, Γ, X, γ, l)
        if status != :Optimal
            return missing
        end

        δ = α + invϕ * h
        fδ, status = relaxedIncrementalProblem(C, c, d, Γ, X, δ, l)
        if status != :Optimal
            return missing
        end

        n = ceil(log(ϵ/h)/log(invϕ))
    end
    for i in 0:n-2
        if Δt > tₗ
            break
        end

        Δt += @elapsed begin
            if fγ > fδ
                # β, δ, fδ = δ, γ, fγ
                β = δ
                δ = γ
                fδ = fγ
                h *=  invϕ
                γ = α + invϕ² * h

                fγ, status = relaxedIncrementalProblem(C, c, d, Γ, X, γ, l)
                if status != :Optimal
                    return missing
                end
            else
                # α, γ, fγ = γ, δ, fδ
                α = γ
                γ = δ
                fγ = fδ
                h *=  invϕ
                δ = α + invϕ * h  # TODO: Why `invphi` here

                fδ, status = relaxedIncrementalProblem(C, c, d, Γ, X, δ, l)
                if status != :Optimal
                    return missing
                end
            end
        end
    end

    if (fγ > fδ)
        μ = (α + γ) / 2
        t, status = relaxedIncrementalProblem(C, c, d, Γ, X, μ, l)
        return if (status != :Optimal) missing else t end
    else
        μ = (γ + β) / 2
        t, status = relaxedIncrementalProblem(C, c, d, Γ, X, μ, l)
        return if (status != :Optimal) missing else t end
    end
end

function relaxedIncrementalProblem(C, c, d, Γ, X, μ, l)
    @assert size(C) == size(c) == size(d)

    n = size(C, 1)

    model = Model(solver = CplexSolver(CPXPARAM_ScreenOutput = getProperty("lagrangianLowerBound.cplexLogging")))

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
    if status == :Optimal
        return getobjectivevalue(model), status
    else
        return getobjectivebound(model), status
    end
end
