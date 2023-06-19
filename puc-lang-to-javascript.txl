include "transpiler-grammar.Grm"

function main 
    replace [program]
        P [program]
    by
        P [string_concat]
end function

rule string_concat
    replace [expression]
        String1 [stringlit] ++ String2 [stringlit] RestStringExpression [repeat expression]
    by
        String1 + String2
end rule

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