export initialScenario

"""
    initialScenario(c, d, Γ)

Heuristic for selecting initial scenario
"""
function initialScenario(c, d, Γ)
    calculateDelta(c, d, m) = collect(max(min(d[i], m - c[i]), 0) for i in 1:length(c))

    l = 0
    r = maximum(map((t) -> sum(t), zip(c, d)))

    delta = []
    while l < r
        m = ceil(Int, (l + r) / 2.0)
        delta = calculateDelta(c, d, m)
        if sum(delta) > Γ
            r = m - 1
        else
            l = m
        end
    end
    delta = reshape(calculateDelta(c, d, l), size(c))
    return c + delta
end
