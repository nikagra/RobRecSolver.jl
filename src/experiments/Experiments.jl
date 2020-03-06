"""
`$(current_module())` is a module containing all of the code regarding conduction of experiments.
"""
module Experiments

using MicroLogging
using LaTeXStrings
using Plots
import PyPlot # workaround due to https://github.com/JuliaPlots/Plots.jl/issues/1047
using DataFrames
using DataArrays
using CSV

importall RobRecSolver

export
    # experiments
    runExperiments,
    exportKnapsackResults,
    exportAssignmentResults,
    getProperties,

    # data generators
    generateData

    files = [
            "data_generators",
            "experiment",
            "export" # Add more files here
        ]

    for file in files
        include("$(file).jl")
    end

end
