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
        timess = []
        ratioss = []
        for α in αs

            numberOfInstances = 5
            times = Array[[] for i=1:4]
            ratios = Array[[] for i=1:4]

            for i = 1:numberOfInstances

                @info "Generating data for instance #$(i) with α=$(α)"

                (C, c, d, Γ, X) = dataGenerator(n)
                c₀ = initialScenario(c, d, Γ)

                @info "Computing recoverable ratio for instance #$(i) with α=$(α)"
                (ρ₀, Δt, x̲, x̅) = computeRecoverableRatio(C, c, d, Γ, X, α, c₀)
                push!(times[1], Δt)
                push!(ratios[1], ρ₀)
                @info "Computation of recoverable ratio for instance #$(i) with α=$(α) has finished in $(Δt) with result $(ρ₀)"

                tic()
                numerator = computeRatioNumerator(C, c, d, Γ, X, α, x̲, x̅)
                Δtₙ = toq()

                @info "Computing adversarial lower bound for instance #$(i) with α=$(α)"
                (ρₐ, Δt) = computeAdversarialLowerBound(C, c, d, Γ, X, α, numerator)
                push!(times[2], Δt + Δtₙ)
                push!(ratios[2], ρₐ)
                @info "Computation of adversarial lower bound for instance #$(i) with α=$(α) has finished in $(Δt + Δtₙ) with result $(ρ₀)"

                @info "Computing recoverable lower bound for instance #$(i) with α=$(α)"
                (ρₕ, Δt) = computeRecoverableLowerBound(C, X, α, c₀, numerator)
                push!(times[3], Δt + Δtₙ)
                push!(ratios[3], ρₕ)
                @info "Computation of recoverable lower bound for instance #$(i) with α=$(α) has finished in $(Δt + Δtₙ) with result $(ρₕ)"

                @info "Computing selection lower bound for instance #$(i) with α=$(α)"
                (ρₛ, Δt) = computeSelectionLowerBound(C, c, d, Γ, X, α, numerator)
                push!(times[4], Δt + Δtₙ)
                push!(ratios[4], ρₛ)
                @info "Computation of selection lower bound for instance #$(i) with α=$(α) has finished in $(Δt + Δtₙ) with result $(ρₛ)"
            end

            @info "Average recoverable ratio for α=$α is $(mean(ratios[1])) was computes in $(@sprintf("%.2f", mean(times[1])))sec on average"
            @info "Average adversarial lower bound for α=$α is $(mean(ratios[2])) was computes in $(@sprintf("%.2f", mean(times[2])))sec on average"
            @info "Average recoverable lower bound for α=$α is $(mean(ratios[3])) was computes in $(@sprintf("%.2f", mean(times[3])))sec on average"
            @info "Average selection lower bound for α=$α is $(mean(ratios[4])) was computes in $(@sprintf("%.2f", mean(times[4])))sec on average"

            push!(timess, mean.(times[2:4]))
            push!(ratioss, mean.(ratios[2:4]))
        end

        drawPlots(αs, ratioss, timess, n)
    end
end

function computeRatioNumerator(C, c, d, Γ, X, α, x̲, x̅)
    obj₁ = evaluationProblem(C, c, d, Γ, α, x̲, X)
    obj₂ = evaluationProblem(C, c, d, Γ, α, x̅, X)
    min(obj₁, obj₂)
end

function computeRecoverableRatio(C, c, d, Γ, X, α, c₀)
    tic()
    (x̲, y̲, t̲) = recoverableProblem(C, c, X, α)
    (x̅, y̅, t̅) = recoverableProblem(C, c + d, X, α)
    (x₀, y₀, t₀) = recoverableProblem(C, c₀, X, α)
    (min(t̲ + Γ, t̅) / t₀, toq(), x̲, x̅)
end

function computeAdversarialLowerBound(C, c, d, Γ, X, α, numerator)
    tic()
    lb = adversarialProblem(C, c, d, Γ, X, α)
    (numerator / lb, toq())
end

function computeRecoverableLowerBound(C, X, α, c₀, numerator)
    tic()
    (x₀, y₀, t₀) = recoverableProblem(C, c₀, X, α)
    (numerator / t₀, toq())
end

function computeSelectionLowerBound(C, c, d, Γ, X, α, numerator)
    tic()
    t₀ = selectionLowerBound(C, c, d, Γ, X, α)
    (numerator / t₀, toq())
end

function computeLagrangianLowerBound(C, c, d, Γ, X, α, numerator)
    tic()
    l = size(c, 1) # TODO: Replace with actual value of l = m (1 - α)
    t₀ = lagrangianLowerBound(C, c, d, Γ, X, l)
    (numerator / t₀, toq())
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
