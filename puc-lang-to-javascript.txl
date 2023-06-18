include "puc-lang.Grm"

function main 
    replace [program]
        P [program]
    by
        P [addition]
end function

rule test
    replace [number]
        15
    by
        37
end rule

rule addition
    replace [expression]
        Number1 [number] + Number2 [number]
    by
        Number1 [+ Number2]
end rule