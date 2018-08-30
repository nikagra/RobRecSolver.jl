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
        println("n = $n:")
        for α in collect(0.1:0.1:0.9)

            numberOfInstances = 5
            times = Array[[] for i=1:4]
            ratios = Array[[] for i=1:4]

            for i = 1:numberOfInstances
                (C, c, d, Γ, X) = dataGenerator(n)
                c₀ = initialScenario(c, d, Γ)

                (ρ₀, Δt, x̲, x̅) = computeRecoverableRatio(C, c, d, Γ, α, X, c₀)
                push!(times[1], Δt)
                push!(ratios[1], ρ₀)

                numerator = computeRatioNumerator(C, c, d, Γ, α, x̲, x̅, X)

                (ρₐ, Δt) = computeAdversarialLowerBound(C, c, d, Γ, α, X, numerator)
                push!(times[2], Δt)
                push!(ratios[2], ρ₀)

                (ρᵣ, Δt) = computeRecoverableLowerBound(C, α, X, c₀, numerator)
                push!(times[3], Δt)
                push!(ratios[3], ρ₀)

                (ρₛ, Δt) = computeSelectionLowerBound(C, c, d, Γ, α, X, numerator)
                push!(times[4], Δt)
                push!(ratios[4], ρ₀)
            end

            println("ρ(c₀): $α ⤑ ($(mean(ratios[1]))) in $(mean(times[1]))sec")
            println("ρₐ: $α ⤑ ($(mean(ratios[2]))) in $(mean(times[2]))sec")
            println("ρᵣ: $α ⤑ ($(mean(ratios[3]))) in $(mean(times[3]))sec")
            println("ρₛ: $α ⤑ ($(mean(ratios[4]))) in $(mean(times[4]))sec")
        end
    end
end

function computeRatioNumerator(C, c, d, Γ, α, x̲, x̅, X)
    obj₁ = evaluationProblem(C, c, d, Γ, α, x̲, X)
    obj₂ = evaluationProblem(C, c, d, Γ, α, x̅, X)
    min(obj₁, obj₂)
end

function computeRecoverableRatio(C, c, d, Γ, α, X, c₀)
    tic()
    (x̲, y̲, t̲) = recoverableProblem(C, c, α, X)
    (x̅, y̅, t̅) = recoverableProblem(C, c + d, α, X)
    (x₀, y₀, t₀) = recoverableProblem(C, c₀, α, X)
    (min(t̲ + Γ, t̅) / t₀, toq(), x̲, x̅)
end

function computeAdversarialLowerBound(C, c, d, Γ, α, X, numerator)
    tic()
    lb = adversarialProblem(C, c, d, Γ, α, X)
    (numerator / lb, toq())
end

function computeRecoverableLowerBound(C, α, X, c₀, numerator)
    tic()
    (x₀, y₀, t₀) = recoverableProblem(C, c₀, α, X)
    (numerator / t₀, toq())
end

function computeSelectionLowerBound(C, c, d, Γ, α, X, numerator)
    tic()
    t₀ = selectionLowerBound(C, c, d, Γ, α, X)
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
