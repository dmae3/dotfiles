# List files with details, using GNU ls when available (mirrors zshrc la alias)
function la
    switch (uname)
        case "Darwin" "*BSD"
            if command -q gnuls
                gnuls -lhAF --color=auto $argv
            else
                ls -lhAFG $argv
            end
        case "SunOS"
            if command -q gls
                gls -lhAF --color=auto $argv
            else
                ls -lhAF $argv
            end
        case "*"
            ls -lhAF --color=auto $argv
    end
end
