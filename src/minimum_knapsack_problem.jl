"""
    minimumKnapsackProblem(C, w, W)

Solve minimum knapsack problem using costs `C`, weights `w` and overall weight limit `W`
"""
function minimumKnapsackProblem(C, w, W)
    @assert length(C) == length(w)

    n = length(C)
    model = Model(solver = CplexSolver(CPXPARAM_ScreenOutput = getProperty("minimumKnapsackProblem.cplexLogging")))
    @variable(model, x[1:n], Bin)
    @objective(model, Min, dot(C, x))

    for constraint in getKnapsackConstraints(w, W)
        JuMP.addconstraint(model, constraint(x))
	end

    status = solve(model)
    return map((x) -> Int(x), getvalue(x))
end

"""
    getKnapsackConstraints(w, W)

Return a list of constraints defining a set of feasible solutions of a minimum knapsack problem.
Each constraint is function with one parameter, which is variable of a mathematical programming model
"""
function getKnapsackConstraints(w, W)
    [x -> @LinearConstraint(vecdot(w, x) >= W)]
end
