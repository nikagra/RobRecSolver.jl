function exportKnapsackResults(n, limit, αs, results)
    @assert size(αs, 1) == size(results, 3)

    pyplot()

    suffix = randstring(4)

    df = DataFrame(a = αs, b = results[1, 1, :])
    saveCsv("kn-plot-ratios-rec-$n-$suffix.csv", df, ["α", "ρ(c_0)"])
    drawAndSavePlot("kn-plot-ratios-rec-$n-$suffix.pdf", αs, results[1, 1, :], L"α", L"average\,ratio\,\rho(c_0)", "n = $n", [:solid])

    df = DataFrame(a = αs, b = results[1, 2, :])
    saveCsv("kn-plot-times-rec-$n-$suffix.csv", df, ["α", "ρ(c_0)"])
    drawAndSavePlot("kn-plot-times-rec-$n-$suffix.pdf", αs, results[1, 2, :], L"α", L"average\,time\,(s.)", "n = $n", [:solid])

    if n ≤ limit
        df = DataFrame(a = αs, ra = results[2, 1, :], rh = results[3, 1, :], rs = results[4, 1, :])
        saveCsv("kn-plot-ratios-adv_rec_sel-$n-$suffix.csv", df, ["α", "ρ_Adv",  "ρ_h",  "ρ_Sel"])
        drawAndSavePlot("kn-plot-ratios-adv_rec_sel-$n-$suffix.pdf", αs, results[2:4, 1, :].', L"α", L"average\,ratio\,\rho_k", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}"], [:solid :dash :dashdot])

        df = DataFrame(a = αs, ra = results[2, 2, :], rh = results[3, 2, :], rs = results[4, 2, :])
        saveCsv("kn-plot-times-adv_rec_sel-$n-$suffix.csv", df, ["α", "ρ_Adv",  "ρ_h",  "ρ_Sel"])
        drawAndSavePlot("kn-plot-times-adv_rec_sel-$n-$suffix.pdf", αs, results[2:4, 2, :].', L"α", L"average\,time\,(s.)", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}"], [:solid :dash :dashdot])
    end
end

function exportAssignmentResults(m, limit, αs, results)
    @assert size(αs, 1) == size(results, 3)

    pyplot()

    suffix = randstring(4)

    df = DataFrame(a = αs, b = results[1, 1, :])
    saveCsv("as-plot-ratios-rec-$m-$suffix.csv", df, ["α", "ρ(c_0)"])
    drawAndSavePlot("as-plot-ratios-rec-$m-$suffix.pdf", αs, results[1, 1, :], L"α", L"average\,ratio\,\rho(c_0)", "m = $m", [:solid])

    df = DataFrame(a = αs, b = results[1, 2, :])
    saveCsv("as-plot-times-rec-$m-$suffix.csv", df, ["α", "ρ(c_0)"])
    drawAndSavePlot("as-plot-times-rec-$m-$suffix.pdf", αs, results[1, 2, :], L"α", L"average\,time\,(s.)", "m = $m", [:solid])

    if m ≤ limit
        df = DataFrame(a = αs, ra = results[2, 1, :], rh = results[3, 1, :], rs = results[4, 1, :], rl = results[5, 1, :])
        saveCsv("as-plot-ratios-adv_rec_sel-$m-$suffix.csv", df, ["α", "ρ_Adv",  "ρ_h",  "ρ_Sel", "ρ_Lag"])
        drawAndSavePlot("as-plot-ratios-adv_rec_sel-$m-$suffix.pdf", αs, results[2:5, 1, :].', L"α", L"average\,ratio\,\rho_k", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}" L"\rho_{Lag}"], [:solid :dash :dashdot])

        df = DataFrame(a = αs, ra = results[2, 2, :], rh = results[3, 2, :], rs = results[4, 2, :], rl = results[5, 2, :])
        saveCsv("as-plot-times-adv_rec_sel-$m-$suffix.csv", df, ["α", "ρ_Adv",  "ρ_h",  "ρ_Sel", "ρ_Lag"])
        drawAndSavePlot("as-plot-times-adv_rec_sel-$m-$suffix.pdf", αs, results[2:5, 2, :].', L"α", L"average\,time\,(s.)", [L"\rho_{Adv}" L"\rho_h" L"\rho_{Sel}" L"\rho_{Lag}"], [:solid :dash :dashdot :dot])
    end
end

function saveCsv(filename, data, columnNames)
    df = DataFrame(data)
    CSV.write(filename, df; colnames = columnNames)
end

function drawAndSavePlot(filename, x, ys, xlabel, ylabel, yslabels, linestyles)
    p = plot(x, ys, xlabel = xlabel, ylabel = ylabel, lab = yslabels, linestyle = linestyles)
    savefig(p, filename)
end
