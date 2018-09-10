function plotKnapsackResults(n, αs, results)
    @assert size(αs, 1) == size(results, 3)

    pyplot()

    suffix = randstring(4)
    drawAndSavePlot(αs, results[1, 1, :], L"α", L"average\,ratio\,\rho(c_0)", "n = $n", "kn-plot-ratios-rec-$n-$suffix.png")
    drawAndSavePlot(αs, results[1, 2, :], L"α", L"average\,time\,(s.)", "n = $n", "kn-plot-times-rec-$n-$suffix.png")
    drawAndSavePlot(αs, results[2:4, 1, :].', L"α", L"average\,ratio\,\rho_k", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}"], "kn-plot-ratios-adv_rec_sel-$n-$suffix.png")
    drawAndSavePlot(αs, results[2:4, 2, :].', L"α", L"average\,time\,(s.)", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}"], "kn-plot-times-adv_rec_sel-$n-$suffix.png")
end

function plotAssignmentResults(m, αs, results)
    @assert size(αs, 1) == size(results, 3)

    pyplot()

    suffix = randstring(4)
    drawAndSavePlot(αs, results[1, 1, :], L"α", L"average\,ratio\,\rho(c_0)", "m = $m", "as-plot-ratios-rec-$m-$suffix.png")
    drawAndSavePlot(αs, results[1, 2, :], L"α", L"average\,time\,(s.)", "m = $m", "as-plot-times-rec-$m-$suffix.png")
    drawAndSavePlot(αs, results[2:5, 1, :].', L"α", L"average\,ratio\,\rho_k", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}" L"\rho_{Lag}"], "as-plot-ratios-adv_rec_sel-$m-$suffix.png")
    drawAndSavePlot(αs, results[2:5, 2, :].', L"α", L"average\,time\,(s.)", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}" L"\rho_{Lag}"], "as-plot-times-adv_rec_sel-$m-$suffix.png")
end

function drawAndSavePlot(x, ys, xlabel, ylabel, yslabels, filename)
    p = plot(x, ys, xlabel = xlabel, ylabel = ylabel, lab = yslabels)
    savefig(p, filename)
end
