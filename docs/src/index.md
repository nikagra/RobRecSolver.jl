# RobRecSolver.jl Documentation
```@docs
RobRecSolver
```
## Solver Functions

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

## Experiments
```@docs
RobRecSolver.Experiments
```

```@docs
RobRecSolver.Experiments.generateData
```

```@docs
RobRecSolver.Experiments.runExperiments
```

```@docs
RobRecSolver.Experiments.runKnapsackExperiments
```

```@docs
RobRecSolver.Experiments.runAssignmentExperiments
```

```@docs
RobRecSolver.Experiments.exportKnapsackResults
```

```@docs
RobRecSolver.Experiments.exportAssignmentResults
```

```@docs
RobRecSolver.Experiments.saveCsv
```

```@docs
RobRecSolver.Experiments.drawAndSavePlot
```

## Utilities
The functions below allow customize package parameters like solver time limits or logging for different algorithms.

```@docs
RobRecSolver.loadProperties
```

```@docs
RobRecSolver.getProperty
```
