# RobRecSolver.jl Documentation

```@contents
```

```@docs
RobRecSolver
```
## Algorithms
There is a number of types and helper functions defined to facilitate implementation
of algorithms of algorithms described in paper.

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

### Problems

```@docs
RobRecSolver.minimumKnapsackProblem
```

```@docs
RobRecSolver.getKnapsackConstraints
```

```@docs
RobRecSolver.minimumAssignmentProblem
```

```@docs
RobRecSolver.getAssignmentConstraints
```

### Testing Framework
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
