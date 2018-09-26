# RobRecSolver.jl Documentation

```@docs
RobRecSolver
```

## Problems
### Minimum Assignment problem

```@docs
minimumAssignmentProblem(C)
```

```@docs
getAssignmentConstraints(m)
```

### Minimum Knapsack problem

```@docs
minimumKnapsackProblem(C, w, W)
```

```@docs
getKnapsackConstraints(w, W)
```

##Solving the problems by MIP formulations

```@docs
recoverableProblem(C, c, α, X)
```

```@docs
incrementalProblem(c, α, x, X)
```

```@docs
evaluationProblem(C, c, d, Γ, α, x, X)
```

## Lower bounds

```@docs
adversarialProblem(C, c, d, Γ, α, X)
```

## Experiments

```@docs
runExperiment(ns, problemDescriptor)
```
