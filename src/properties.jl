configKey = "ROBRECSOLVER_CONFIG"

"""
    loadProperties()

Loads properties stored in an INI file from the specified file location. To change default location set `$configKey` environment variable either in Julia REPL or in `~/.julia/config/startup.jl` and then reload $(current_module()) package:
```julia-repl
julia> ENV[$configKey] = "<path_to_file>"
julia> Pkg.reload("RobRecSolver")
```
Use default properties file `Pkg.dir("RobRecSolver")/conf/config.ini` as a reference.

In order to reset changes simply delete environment variable and reload $(current_module()) package.
"""
loadProperties = let

    function loadProperties()
        path = joinpath("$(Pkg.dir("RobRecSolver"))", "conf", "config.ini")
        if haskey(ENV, configKey)
            path = ENV[configKey]
        end
        @debug "Loading config from $path. If you want to change default config please set up $configKey environment variable"
        conf = ConfParse(path)
        parse_conf!(conf)
        conf
    end

end

"""
    getProperty(parameter[, parameterType, section])

Get value for key of name `parameter` of type `parameterType` from section `section` from either default properties files or the one specified with a path in $configKey.
Argument  `parameterType` defaults to `Int` and `section` defaults to `main`.
"""
getProperty = let

    properties = loadProperties()

    function getProperty(parameter; parameterType=Int, section = "main")
        parse(parameterType, retrieve(properties, section, parameter))
    end

end
