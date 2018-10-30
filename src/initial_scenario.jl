"""
    initialScenario(c, d, Γ)

Heuristic for selecting initial scenario
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
