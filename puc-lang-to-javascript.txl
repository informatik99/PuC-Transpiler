include "transpiler-grammar.Grm"

function main 
    replace [program]
        P [program]
    by
        P [varDeclaration] 
        [makeLambdaWithType] 
        [makeLambda] 
        [stringConcat]
end function

% funktioniert :)
rule stringConcat
    replace [string_concat] 
        String1 [stringlit] ++ StringConcat [string_concat]
    by
        String1 + StringConcat [helpStringConcat]
end rule

rule helpStringConcat
    replace [string_concat]
        String [stringlit] ++ String2 [stringlit]
    by
        String + String2
end rule

% funktioniert :)
rule varDeclaration
    replace [var_declaration]
        let Variable [id] '= Expr1 [expression] in Expr2 [expression]
    by
        var Variable '= Expr1 Expr2 % Die Zeilenumbrüche müssen hier nicht stehen sondern in der .Grm Datei
end rule


rule makeLambda
    replace [lambda]
        fn Param [id] => Expr [expression]
    by
        '( Param ') => '{ Expr '}
end rule

rule makeLambdaWithType
    replace [lambda]
        fn Param [id] : Type [type] => Expr [expression]
    by
        '( Param ') => '{ Expr '}
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