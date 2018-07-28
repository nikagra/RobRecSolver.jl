using RobRecSolver
using JuMP, Cbc

export EVAL

"""
    Eval(C, c, d, Γ, α, x, X)

Compute Eval(x) with accuracy ϵ
"""
function EVAL(C, c, d, Γ, α, x, X)
    ub = Inf
    c₀ = initialScenario(c, d, Γ)
    (y, lb) = INC(c₀, α, x, X)
    Y = [y]
    while (ub - lb)/lb > 0.01
        (c̃, t̃) = ADV(c, d, Γ, Y)
        ub = t̃
        (y, nlb) = INC(c̃, α, x, X)
        if lb < nlb
            lb = nlb
        end
        push!(Y, y)
    end
    vecdot(C, x) + ub
end

function INC(c, α, x, X)
    n = size(c, 1)

    model = Model(solver=CbcSolver())
    if ndims(c) == 1
        @variable(model, y[1:n], Bin)
    elseif ndims(c) == 2
        m = size(c, 2)
        @variable(model, y[1:n, 1:m], Bin)
    else
        throw(ArgumentError("Unsupported number of dimensions ($(ndims(c)))"))
    end

    @objective(model, Min, vecdot(c, y))

    @constraint(model, vecdot(x, 1 - y) <= α * sum(x))

    # Constraints defining set of feasible solutions
    for constraint in X
        JuMP.addconstraint(model, constraint(y))
    end

    status = solve(model)
    return (map(x -> Int(x), getvalue(y)), getobjectivevalue(model))
end

function ADV(c, d, Γ, Y)
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

    @constraint(model, [y in Y], t̃ <= vecdot(c̃, y))

    @constraint(model, c̃ .>= c)
    @constraint(model, c̃ .<= c + d)
    @constraint(model, sum(c̃ - c) <= Γ)

    status = solve(model)
    return (getvalue(c̃), getvalue(t̃))
end
