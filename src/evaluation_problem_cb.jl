function evaluationProblemWithCallback(C, c, d, Γ, α, x, X, pd)
    n = size(c, 1)
    numCallbacks = 0

    ub = Inf
    c₀ = initialScenario(c, d, Γ)
    (y, lb) = incrementalProblem(c₀, α, x, X, pd)

    model = Model(solver=CplexSolver(CPX_PARAM_TILIM = CPX_PARAM_TILIM = getProperty("evaluationProblem.timeLimit"),
        CPXPARAM_ScreenOutput = getProperty("evaluationProblem.cplexLogging")))

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
    @constraint(model, t̃ <= vecdot(c̃, y))

    function callback(cb)
        if (ub - lb)/lb > 0.01
            c̅ = getvalue(c̃)
            t̅ = getvalue(t̃)

            ub = t̅
            (y, nlb) = incrementalProblem(c̅, α, x, X, pd)
            if lb < nlb
                lb = nlb
            end
            @lazyconstraint(cb, t̃ <= vecdot(c̃, y))

            numCallbacks += 1
        end
    end

    addlazycallback(model, callback, fractional=true)

    status = solve(model)

    @debug "$numCallbacks constraints was added to this evaluation problem"

    vecdot(C, x) + ub
end
