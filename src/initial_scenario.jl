"""
    initialScenario(c, d, Γ)

Returns a good initial scenario ``c_0``. It is used in computation of [`evaluationProblem`](@ref)
and [`adversarialProblem`](@ref).

Check section 5.1 _Adversarial lower bound_ of [publication](https://arxiv.org/abs/1811.06719)
for more information about this algorithm.

# Arguments
- `c`: vector of nonnegative nominal second stage costs.
- `d`: vector of maximal deviations of the costs from their nominal values.
- `Γ`: budget, or the amount of uncertainty, which can be allocated to the second stage costs
"""
function initialScenario(c, d, Γ)
    calculateDelta(c, d, m) = collect(max(min(d[i], m - c[i]), 0) for i in 1:length(c))

    ϵ = 0.001
    l = 0
    m = 0
    r = maximum(map((t) -> sum(t), zip(c, d)))

    δ = []
    while abs(l - r) >= ϵ
        m = (l + r) / 2.0
        δ = calculateDelta(c, d, m)
        if sum(δ) > Γ
            r = m
        else
            l = m
        end
    end

    δ = reshape(calculateDelta(c, d, m), size(c))
    return c + δ
end
