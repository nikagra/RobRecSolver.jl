"""
    runExperiments(ns::Array{Integer}, ms::Array{Integer}; numberOfInstances = 5)

Run experiments

# Examples:
```julia-repl
julia> using RobRecSolver
julia> runExperiments([100, 400, 1000], [10, 25, 100]])
```
"""
function runExperiments(ns::Array{Int}, ms::Array{Int}; αs = collect(0.1:0.1:0.9), numberOfInstances = 5)
    srand(310923)

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

        dataGenerator = KnapsackDataGenerator(n)
        resultss = []

        for α in αs

            reducer(m₁, m₂) = vcat(m₁, m₂)
            reduced = @parallel (reducer) for i = 1:numberOfInstances
                generateInstanceAndCalculateRatiosWithoutEqualCardinality(α, dataGenerator, i)
            end
            results = squeeze(mean(reduced, 1), 1)

            @info "Average recoverable ratio for α=$α is $(mean(results[1, 1])) was computed in $(@sprintf("%.2f", mean(results[1, 2])))sec on average"
            @info "Average adversarial lower bound for α=$α is $(mean(results[2, 1])) was computed in $(@sprintf("%.2f", mean(results[2, 2])))sec on average"
            @info "Average recoverable lower bound for α=$α is $(mean(results[3, 1])) was computed in $(@sprintf("%.2f", mean(results[3, 2])))sec on average"
            @info "Average selection lower bound for α=$α is $(mean(results[4, 1])) was computed in $(@sprintf("%.2f", mean(results[4, 2])))sec on average"

            push!(resultss, results)
        end

        resultss = cat(3, resultss...)
        plotKnapsackResults(n, αs, resultss)
    end
end

function runAssignmentExperiments(ms; αs = collect(0.1:0.1:0.9), numberOfInstances = 5)
    for m in ms
        @info "Starting minimum assignment problem experiment for m = $(m)..."

        dataGenerator = AssignmentDataGenerator(m)
        resultss = []

        for α in αs

            reducer(m₁, m₂) = vcat(m₁, m₂)
            reduced = @parallel (reducer) for i = 1:numberOfInstances
                generateInstanceAndCalculateRatiosWithEqualCardinality(α, dataGenerator, i)
            end
            results = squeeze(mean(reduced, 1), 1)

            @info "Average recoverable ratio for α=$α is $(mean(results[1, 1])) was computed in $(@sprintf("%.2f", mean(results[1, 2])))sec on average"
            @info "Average adversarial lower bound for α=$α is $(mean(results[2, 1])) was computed in $(@sprintf("%.2f", mean(results[2, 2])))sec on average"
            @info "Average recoverable lower bound for α=$α is $(mean(results[3, 1])) was computed in $(@sprintf("%.2f", mean(results[3, 2])))sec on average"
            @info "Average selection lower bound for α=$α is $(mean(results[4, 1])) was computed in $(@sprintf("%.2f", mean(results[4, 2])))sec on average"
            @info "Average lagrangian lower bound for α=$α is $(mean(results[5, 1])) was computed in $(@sprintf("%.2f", mean(results[5, 2])))sec on average"

            push!(resultss, results)
        end

        resultss = cat(3, resultss...)
        plotAssignmentResults(m, αs, resultss)
    end
end

function generateInstanceAndCalculateRatiosWithoutEqualCardinality(α, dataGenerator::DataGenerator, i)
    @assert !hasEqualCardinalityProperty(dataGenerator) "The problem is expected to has equal cardinality property"

    @info "Generating data for instance #$(i) with α=$(α)"
    (C, c, d, Γ, X) = generateData(dataGenerator)
    c₀ = initialScenario(c, d, Γ)

    @info "Computing recoverable ratio for instance #$(i) with α=$(α)"
    Δt₀ = @elapsed (ρ₀, x̲, x̅) = computeRecoverableRatio(C, c, d, Γ, X, α, c₀)
    @info "Computation of recoverable ratio for instance #$(i) with α=$(α) has finished in $(Δt₀)sec. with result $(ρ₀)"

    Δtₙ = @elapsed numerator = computeRatioNumerator(C, c, d, Γ, X, α, x̲, x̅)

    @info "Computing adversarial lower bound for instance #$(i) with α=$(α)"
    Δtₐ = @elapsed ρₐ = computeAdversarialLowerBound(C, c, d, Γ, X, α, numerator)
    @info "Computation of adversarial lower bound for instance #$(i) with α=$(α) has finished in $(Δtₐ + Δtₙ)sec. with result $(ρₐ)"

    @info "Computing recoverable lower bound for instance #$(i) with α=$(α)"
    Δtₕ = @elapsed ρₕ = computeRecoverableLowerBound(C, X, α, c₀, numerator)
    @info "Computation of recoverable lower bound for instance #$(i) with α=$(α) has finished in $(Δtₕ + Δtₙ)sec. with result $(ρₕ)"

    @info "Computing selection lower bound for instance #$(i) with α=$(α)"
    Δtₛ = @elapsed ρₛ = computeSelectionLowerBound(C, c, d, Γ, X, α, numerator)
    @info "Computation of selection lower bound for instance #$(i) with α=$(α) has finished in $(Δtₛ + Δtₙ)sec. with result $(ρₛ)"

    cat(3, [ρ₀ ρₐ ρₕ ρₛ], [Δt₀ (Δtₐ + Δtₙ) (Δtₕ + Δtₙ) (Δtₛ + Δtₙ)])
end

function generateInstanceAndCalculateRatiosWithEqualCardinality(α, dataGenerator::DataGenerator, i)
    @assert hasEqualCardinalityProperty(dataGenerator) "The problem is expected to has equal cardinality property"

    @info "Generating data for instance #$(i) with α=$(α)"
    (C, c, d, Γ, X) = generateData(dataGenerator)
    c₀ = initialScenario(c, d, Γ)

    @info "Computing recoverable ratio for instance #$(i) with α=$(α)"
    Δt₀ = @elapsed (ρ₀, x̲, x̅) = computeRecoverableRatio(C, c, d, Γ, X, α, c₀)
    @info "Computation of recoverable ratio for instance #$(i) with α=$(α) has finished in $(Δt₀)sec. with result $(ρ₀)"

    Δtₙ = @elapsed numerator = computeRatioNumerator(C, c, d, Γ, X, α, x̲, x̅)

    @info "Computing adversarial lower bound for instance #$(i) with α=$(α)"
    Δtₐ = @elapsed ρₐ = computeAdversarialLowerBound(C, c, d, Γ, X, α, numerator)
    @info "Computation of adversarial lower bound for instance #$(i) with α=$(α) has finished in $(Δtₐ + Δtₙ)sec. with result $(ρₐ)"

    @info "Computing recoverable lower bound for instance #$(i) with α=$(α)"
    Δtₕ = @elapsed ρₕ = computeRecoverableLowerBound(C, X, α, c₀, numerator)
    @info "Computation of recoverable lower bound for instance #$(i) with α=$(α) has finished in $(Δtₕ + Δtₙ)sec. with result $(ρₕ)"

    @info "Computing selection lower bound for instance #$(i) with α=$(α)"
    Δtₛ = @elapsed ρₛ = computeSelectionLowerBound(C, c, d, Γ, X, α, numerator)
    @info "Computation of selection lower bound for instance #$(i) with α=$(α) has finished in $(Δtₛ + Δtₙ)sec. with result $(ρₛ)"

    @info "Computing Lagrangian lower bound for instance #$(i) with α=$(α)"
    Δtₗ = @elapsed ρₗ = computeLagrangianLowerBound(C, c, d, Γ, X, α, numerator)
    @info "Computation of Lagrangian lower bound for instance #$(i) with α=$(α) has finished in $(Δtₛ + Δtₙ)sec. with result $(ρₛ)"

    cat(3, [ρ₀ ρₐ ρₕ ρₛ ρₗ], [Δt₀ (Δtₐ + Δtₙ) (Δtₕ + Δtₙ) (Δtₛ + Δtₙ) (Δtₗ + Δtₙ)])
end

function computeRatioNumerator(C, c, d, Γ, X, α, x̲, x̅)
    obj₁ = evaluationProblem(C, c, d, Γ, α, x̲, X)
    obj₂ = evaluationProblem(C, c, d, Γ, α, x̅, X)
    min(obj₁, obj₂)
end

function computeRecoverableRatio(C, c, d, Γ, X, α, c₀)
    (x̲, y̲, t̲) = recoverableProblem(C, c, X, α)
    (x̅, y̅, t̅) = recoverableProblem(C, c + d, X, α)
    (x₀, y₀, t₀) = recoverableProblem(C, c₀, X, α)
    (min(t̲ + Γ, t̅) / t₀, x̲, x̅)
end

function computeAdversarialLowerBound(C, c, d, Γ, X, α, numerator)
    lb = adversarialProblem(C, c, d, Γ, X, α)
    numerator / lb
end

function computeRecoverableLowerBound(C, X, α, c₀, numerator)
    (x₀, y₀, t₀) = recoverableProblem(C, c₀, X, α)
    numerator / t₀
end

function computeSelectionLowerBound(C, c, d, Γ, X, α, numerator)
    t₀ = selectionLowerBound(C, c, d, Γ, X, α)
    numerator / t₀
end

function computeLagrangianLowerBound(C, c, d, Γ, X, α, numerator)
    l = ceil(size(c, 1) * (1 - α))
    t₀ = lagrangianLowerBound(C, c, d, Γ, X, l)
    numerator / t₀
end
