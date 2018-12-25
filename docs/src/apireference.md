# Reference

## Problems

### Incremental Problem

```@docs
RobRecSolver.incrementalProblem
```

### Evaluation Problem

```@docs
RobRecSolver.evaluationProblem
```

### Recoverable Problem

```@docs
RobRecSolver.recoverableProblem
```

### Adversarial Problem

```@docs
RobRecSolver.adversarialProblem
```

### Selection Lower Bound

```@docs
RobRecSolver.selectionLowerBound
```

### Lagrangian Lower Bound

```@docs
RobRecSolver.lagrangianLowerBound
```

## Additional Types and functions
There is a number of types and helper functions defined to facilitate implementation
of algorithms described in _publication_.

```@docs
RobRecSolver.ProblemDescriptor
```

```@docs
RobRecSolver.KnapsackProblemDescriptor
```

```@docs
RobRecSolver.AssignmentProblemDescriptor
```

```@docs
RobRecSolver.getProblemSize
```

```@docs
RobRecSolver.getSaneComputationLimit
```

```@docs
RobRecSolver.hasEqualCardinalityProperty
```

```@docs
RobRecSolver.getCardinality
```

```@docs
RobRecSolver.initialScenario
```

## Utilities
The functions below allow customize package parameters like solver time limits or logging for different algorithms.

```@docs
RobRecSolver.loadProperties
```

```@docs
RobRecSolver.getProperty
```
