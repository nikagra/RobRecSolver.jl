function adversarialProblemWithCallback(C, c, d, Γ, X, α)
    n = size(c, 1)

    ub = Inf
    c₀ = initialScenario(c, d, Γ)
    (x₀, y₀, lb) = recoverableProblem(C, c₀, X, α)

    model = Model(solver=CplexSolver(CPX_PARAM_TILIM = 600, CPXPARAM_ScreenOutput = 0))

    @variable(model, dummy, Int) # needed for callback to be called
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

    @constraint(model, c̃ .>= c)
    @constraint(model, c̃ .<= c + d)
    @constraint(model, sum(c̃ - c) <= Γ)
    @constraint(model, t̃ <= vecdot(C, x₀) + vecdot(c̃, y₀))

    function corners(cb)
        if (ub - lb)/lb > 0.01
            c̅ = getvalue(c̃)
            t̅ = getvalue(t̃)

            ub = t̅
            (x, y, nlb) = recoverableProblem(C, c̅, X, α)
            if lb < nlb
                lb = nlb
            end
            @lazyconstraint(cb, t̃ <= vecdot(C, x) + vecdot(c̃, y))
        end
    end

    addlazycallback(model, corners, fractional=true)

    status = solve(model)

    lb
end
