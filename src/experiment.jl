"""
Run experiment computing ratio ρ(c₀) with specified `n` and data generator.

# Examples:
```julia-repl
julia> using RobRecSolver
julia> runExperiment([100, 400, 1000], generateKnapsackData)
```
"""
function runExperiment(ns, dataGenerator)
    for n in ns
        @info "Starting computation for n = $(n)..."
        αs = collect(0.1:0.1:0.9)
        resultss = []
        for α in αs

            numberOfInstances = 5
            times = Array[[] for i=1:4]
            ratios = Array[[] for i=1:4]

            reducer(m₁, m₂) = mean(hcat(m₁, m₂), 2)
            reduced = @parallel (reducer) for i = 1:numberOfInstances
                generateInstanceAndCalculateRatios(n, α, dataGenerator, i)
            end
            results = squeeze(reduced, 2)

            @info "Average recoverable ratio for α=$α is $(mean(results[1, 1])) was computes in $(@sprintf("%.2f", mean(results[1, 2])))sec on average"
            @info "Average adversarial lower bound for α=$α is $(mean(results[2, 1])) was computes in $(@sprintf("%.2f", mean(results[2, 2])))sec on average"
            @info "Average recoverable lower bound for α=$α is $(mean(results[3, 1])) was computes in $(@sprintf("%.2f", mean(results[3, 2])))sec on average"
            @info "Average selection lower bound for α=$α is $(mean(results[4, 1])) was computes in $(@sprintf("%.2f", mean(results[4, 2])))sec on average"

            push!(resultss, mean.(results[2:4, :]))
        end

        ratios = [resultss[i][:,1] for i in 1:size(resultss,1)]
        times = [resultss[i][:,2] for i in 1:size(resultss,1)]
        drawPlots(αs, ratios, times, n)
    end
end

function generateInstanceAndCalculateRatios(n, α, dataGenerator, i)
    @info "Generating data for instance #$(i) with α=$(α)"

    (C, c, d, Γ, X) = dataGenerator(n)
    c₀ = initialScenario(c, d, Γ)

    @info "Computing recoverable ratio for instance #$(i) with α=$(α)"
    Δt₀ = @elapsed (ρ₀, x̲, x̅) = computeRecoverableRatio(C, c, d, Γ, X, α, c₀)
    @info "Computation of recoverable ratio for instance #$(i) with α=$(α) has finished in $(Δt₀) with result $(ρ₀)"

    Δtₙ = @elapsed numerator = computeRatioNumerator(C, c, d, Γ, X, α, x̲, x̅)

    @info "Computing adversarial lower bound for instance #$(i) with α=$(α)"
    Δtₐ = @elapsed ρₐ = computeAdversarialLowerBound(C, c, d, Γ, X, α, numerator)
    @info "Computation of adversarial lower bound for instance #$(i) with α=$(α) has finished in $(Δtₐ + Δtₙ) with result $(ρₐ)"

    @info "Computing recoverable lower bound for instance #$(i) with α=$(α)"
    Δtₕ = @elapsed ρₕ = computeRecoverableLowerBound(C, X, α, c₀, numerator)
    @info "Computation of recoverable lower bound for instance #$(i) with α=$(α) has finished in $(Δtₕ + Δtₙ) with result $(ρₕ)"

    @info "Computing selection lower bound for instance #$(i) with α=$(α)"
    Δtₛ = @elapsed ρₛ = computeSelectionLowerBound(C, c, d, Γ, X, α, numerator)
    @info "Computation of selection lower bound for instance #$(i) with α=$(α) has finished in $(Δtₛ + Δtₙ) with result $(ρₛ)"

    cat(3, [ρ₀; ρₐ; ρₕ; ρₛ], [Δt₀; Δtₐ + Δtₙ; Δtₕ + Δtₙ; Δtₛ + Δtₙ])
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
    l = size(c, 1) # TODO: Replace with actual value of l = m (1 - α)
    t₀ = lagrangianLowerBound(C, c, d, Γ, X, l)
    numerator / t₀
end

function generateKnapsackData(n)
    C = rand(1:20, n)
    c = rand(1:20, n)
    d = rand(1:100, n)
    Γ = floor(Int, 0.1 * sum(d))
    w = rand(1:20, n)
    W = floor(Int, 0.3 * sum(w))
    X = getKnapsackConstraints(w, W)
    (C, c, d, Γ, X)
end

function generateAssignmentData(m)
    C = rand(1:20, m, m)
    c = rand(1:20, m, m)
    d = rand(1:100, m, m)
    Γ = floor(Int, 0.1 * sum(d))
    X = getAssignmentConstraints(m)
    (C, c, d, Γ, X)
end
