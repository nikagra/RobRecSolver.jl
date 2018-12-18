"""
    runExperiments(ns::Array{Integer}, ms::Array{Integer}; numberOfInstances = 5)

Main function to run experiments

# Examples:
```julia-repl
julia> using RobRecSolver
julia> runExperiments([100, 400, 1000], [10, 25, 100]])
```
"""
function runExperiments(ns::Array{Int}, ms::Array{Int}; αs = collect(0.1:0.1:0.9), numberOfInstances = 5)

    @info "Starting experiments for minimum knapsack problem for n in $ns"
    Δt = @elapsed runKnapsackExperiments(ns, αs = αs, numberOfInstances = numberOfInstances)
    @info "Experiments for minimum knapsack problem have finished in $(Δt)sec"

    @info "Starting experiments for minimum assignment problem for m in $ms"
    Δt = @elapsed runAssignmentExperiments(ms, αs = αs, numberOfInstances = numberOfInstances)
    @info "Experiments for minimum assignment problem have finished in $(Δt)sec"
end


function runKnapsackExperiments(ns; αs = collect(0.1:0.1:0.9), numberOfInstances = 5)
    for n in ns
        @info "Starting minimum knapsack problem experiment for n = $(n)..."

        srand(310923)

        problemDescriptor = KnapsackProblemDescriptor(n)
        resultss = []

        for α in αs

            reducer(m₁, m₂) = vcat(m₁, m₂)
            reduced = @parallel (reducer) for i = 1:numberOfInstances
                generateInstanceAndCalculateRatios(α, problemDescriptor, i)
            end
            results = squeeze(mean(convert(DataArray, reduced), 1; skipmissing = true), 1)

            @info "Average recoverable ratio for α=$α is $(mean(results[1, 1])) was computed in $(@sprintf("%.2f", mean(results[1, 2])))sec on average"
            if getProblemSize(problemDescriptor) ≤ getSaneComputationLimit(problemDescriptor)
                @info "Average adversarial lower bound for α=$α is $(mean(results[2, 1])) was computed in $(@sprintf("%.2f", mean(results[2, 2])))sec on average"
                @info "Average recoverable lower bound for α=$α is $(mean(results[3, 1])) was computed in $(@sprintf("%.2f", mean(results[3, 2])))sec on average"
                @info "Average selection lower bound for α=$α is $(mean(results[4, 1])) was computed in $(@sprintf("%.2f", mean(results[4, 2])))sec on average"
            end

            push!(resultss, results)
        end

        resultss = cat(3, resultss...)
        exportKnapsackResults(n, getSaneComputationLimit(problemDescriptor), αs, resultss)
    end
end

function runAssignmentExperiments(ms; αs = collect(0.1:0.1:0.9), numberOfInstances = 5)
    for m in ms
        @info "Starting minimum assignment problem experiment for m = $(m)..."

        srand(310923)

        problemDescriptor = AssignmentProblemDescriptor(m)
        resultss = []

        for α in αs

            reducer(m₁, m₂) = vcat(m₁, m₂)
            reduced = @parallel (reducer) for i = 1:numberOfInstances
                generateInstanceAndCalculateRatios(α, problemDescriptor, i)
            end
            results = squeeze(mean(convert(DataArray, reduced), 1; skipmissing = true), 1)

            @info "Average recoverable ratio for α=$α is $(mean(results[1, 1])) was computed in $(@sprintf("%.2f", mean(results[1, 2])))sec on average"
            if getProblemSize(problemDescriptor) ≤ getSaneComputationLimit(problemDescriptor)
                @info "Average adversarial lower bound for α=$α is $(mean(results[2, 1])) was computed in $(@sprintf("%.2f", mean(results[2, 2])))sec on average"
                @info "Average recoverable lower bound for α=$α is $(mean(results[3, 1])) was computed in $(@sprintf("%.2f", mean(results[3, 2])))sec on average"
                @info "Average selection lower bound for α=$α is $(mean(results[4, 1])) was computed in $(@sprintf("%.2f", mean(results[4, 2])))sec on average"
                @info "Average lagrangian lower bound for α=$α is $(mean(results[5, 1])) was computed in $(@sprintf("%.2f", mean(results[5, 2])))sec on average"


                solvedLagrangianPoblems = count(i -> !ismissing(i), reduced[:, 5, 1])
                @warn "$solvedLagrangianPoblems out of $numberOfInstances lagrangian lower bound problems was solved optimaly for α=$α"
            end

            push!(resultss, results)
        end

        resultss = cat(3, resultss...)
        exportAssignmentResults(m, getSaneComputationLimit(problemDescriptor), αs, resultss)
    end
end

function generateInstanceAndCalculateRatios(α, problemDescriptor::ProblemDescriptor, i)

    @info "Generating data for instance #$(i) with α=$(α)"
    (C, c, d, Γ, X) = generateData(problemDescriptor)
    c₀ = initialScenario(c, d, Γ)

    @info "Computing recoverable ratio for instance #$(i) with α=$(α)"
    Δt₀ = @elapsed (ρ₀, x̲, x̅) = computeRecoverableRatio(C, c, d, Γ, X, α, c₀, problemDescriptor)
    @info "Computation of recoverable ratio for instance #$(i) with α=$(α) has finished in $(Δt₀)sec. with result $(ρ₀)"

    if getProblemSize(problemDescriptor) > getSaneComputationLimit(problemDescriptor)
        return cat(3, [ρ₀], [Δt₀])
    end

    Δtₙ = @elapsed numerator = computeRatioNumerator(C, c, d, Γ, X, α, x̲, x̅, problemDescriptor)
    @debug "Ratio numerator for for instance #$(i) with α=$(α) was calculated in $(Δtₙ)sec."

    @info "Computing adversarial lower bound for instance #$(i) with α=$(α)"
    Δtₐ = @elapsed ρₐ = computeAdversarialLowerBound(C, c, d, Γ, X, α, numerator, problemDescriptor)
    @info "Computation of adversarial lower bound for instance #$(i) with α=$(α) has finished in $(Δtₐ + Δtₙ)sec. with result $(ρₐ)"

    @info "Computing recoverable lower bound for instance #$(i) with α=$(α)"
    Δtₕ = @elapsed ρₕ = computeRecoverableLowerBound(C, X, α, c₀, numerator, problemDescriptor)
    @info "Computation of recoverable lower bound for instance #$(i) with α=$(α) has finished in $(Δtₕ + Δtₙ)sec. with result $(ρₕ)"

    @info "Computing selection lower bound for instance #$(i) with α=$(α)"
    Δtₛ = @elapsed ρₛ = computeSelectionLowerBound(C, c, d, Γ, X, α, numerator, problemDescriptor)
    @info "Computation of selection lower bound for instance #$(i) with α=$(α) has finished in $(Δtₛ + Δtₙ)sec. with result $(ρₛ)"

    if hasEqualCardinalityProperty(problemDescriptor)
        @assert hasEqualCardinalityProperty(problemDescriptor) "The problem is expected to has equal cardinality property"

        @info "Computing Lagrangian lower bound for instance #$(i) with α=$(α)"
        Δtₗ = @elapsed ρₗ = computeLagrangianLowerBound(C, c, d, Γ, X, α, numerator, problemDescriptor)
        @info "Computation of Lagrangian lower bound for instance #$(i) with α=$(α) has finished in $(Δtₗ + Δtₙ)sec. with result $(ρₗ)"

        cat(3, [ρ₀ ρₐ ρₕ ρₛ ρₗ numerator], [Δt₀ (Δtₐ + Δtₙ) (Δtₕ + Δtₙ) (Δtₛ + Δtₙ) (Δtₗ + Δtₙ) Δtₙ])
    else
        cat(3, [ρ₀ ρₐ ρₕ ρₛ numerator], [Δt₀ (Δtₐ + Δtₙ) (Δtₕ + Δtₙ) (Δtₛ + Δtₙ) Δtₙ])
    end
end

function computeRatioNumerator(C, c, d, Γ, X, α, x̲, x̅, problemDescriptor)
    obj₁ = evaluationProblem(C, c, d, Γ, α, x̲, X, problemDescriptor)
    obj₂ = evaluationProblem(C, c, d, Γ, α, x̅, X, problemDescriptor)
    min(obj₁, obj₂)
end

function computeRecoverableRatio(C, c, d, Γ, X, α, c₀, problemDescriptor)
    (x̲, y̲, t̲) = recoverableProblem(C, c, X, α, problemDescriptor)
    (x̅, y̅, t̅) = recoverableProblem(C, c + d, X, α, problemDescriptor)
    (x₀, y₀, t₀) = recoverableProblem(C, c₀, X, α, problemDescriptor)
    (min(t̲ + Γ, t̅) / t₀, x̲, x̅)
end

function computeAdversarialLowerBound(C, c, d, Γ, X, α, numerator, problemDescriptor)
    lb = adversarialProblem(C, c, d, Γ, X, α, problemDescriptor)
    numerator / lb
end

function computeRecoverableLowerBound(C, X, α, c₀, numerator, problemDescriptor)
    (x₀, y₀, t₀) = recoverableProblem(C, c₀, X, α, problemDescriptor)
    numerator / t₀
end

function computeSelectionLowerBound(C, c, d, Γ, X, α, numerator, problemDescriptor::ProblemDescriptor)
    t₀ = selectionLowerBound(C, c, d, Γ, X, α, problemDescriptor)
    numerator / t₀
end

function computeLagrangianLowerBound(C, c, d, Γ, X, α, numerator, problemDescriptor::ProblemDescriptor)
    l = ceil(size(c, 1) * (1 - α))
    t₀ = lagrangianLowerBound(C, c, d, Γ, X, l, problemDescriptor)
    numerator / t₀
end
