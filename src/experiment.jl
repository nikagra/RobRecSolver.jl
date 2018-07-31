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
            times = []
            ratios = []
            for i = 1:10
                (C, c, d, Γ, X) = dataGenerator(n)
                c₀ = initialScenario(c, d, Γ)
                tic()
                ρ = min(recoverableProblem(C, c, α, X)[3] + Γ, recoverableProblem(C, c + d, α, X)[3]) / recoverableProblem(C, c₀, α, X)[3]
                push!(times, toq())
                push!(ratios, ρ)
            end
            @assert length(ratios) == 10
            @assert length(times) == 10
            println("$α ⤑ ($(minimum(ratios)), $(mean(ratios)), $(maximum(ratios))) in $(mean(times))sec")
        end
    end
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
