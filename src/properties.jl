getProperty = let
    function loadProperties()
        path = "$(Pkg.dir("RobRecSolver"))/conf/config.ini"
        @debug "Reading property file from $path"
        conf = ConfParse(path)
        parse_conf!(conf)
        conf
    end

    properties = loadProperties()

    function getProperty(parameter; parameterType=Int, section = "main")
        parse(parameterType, retrieve(properties, section, parameter))
    end
end
