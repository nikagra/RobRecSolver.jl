function drawPlots(αs, ratioss, timess, n)
    suffix = randstring(4)

    labels = ["adv" "h" "sel"]
    p = plot(αs, transposeData(ratioss), lab = labels, xlabel = "a", ylabel = "average ratio")
    savefig(p, "plot-ratios-$(n)-$(suffix).png")

    labels = ["adv" "h" "sel"]
    p = plot(αs, transposeData(timess), lab = labels, xlabel = "a", ylabel = "average time (s.)")
    savefig(p, "plot-times-$(n)-$(suffix).png")
end

function transposeData(data)
    [hcat(data...)[i, :] for i in 1:size(hcat(data...), 1)]
end
