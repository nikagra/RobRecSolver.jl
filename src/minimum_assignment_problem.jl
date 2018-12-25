"""
    minimumAssignmentProblem(C)

Solve minimum assignment problem using vector of costs `C`.
"""
function minimumAssignmentProblem(C)
    @assert ndims(C) == 2 && size(C, 1) == size(C, 2)

    m = size(C, 1)
    model = Model(solver = CplexSolver(CPXPARAM_ScreenOutput = getProperty("minimumAssignmentProblem.cplexLogging")))
    @variable(model, x[1:m, 1:m], Bin)
    @objective(model, Min, vecdot(C, x))

    for constraint in getAssignmentConstraints(m)
        JuMP.addconstraint(model, constraint(x))
	end

    status = solve(model)
    return map((x) -> Int(x), getvalue(x))
end

"""
    getAssignmentConstraints(m)

Return a list of constraints defining a set of feasible solutions of a minimum assignment problem.
Each constraint is function with one parameter, which is variable of a mathematical programming model.
"""
function getAssignmentConstraints(m)
    constraints = []
    for j in 1:m
        push!(constraints, x-> @LinearConstraint(sum(x[i,j] for i=1:m)==1))
    end
    for i in 1:m
        push!(constraints, x -> @LinearConstraint(sum(x[i,j] for j=1:m)==1))
    end
    constraints
end
