include "transpiler-grammar.Grm"

function main 
    replace [program]
        P [program]
    by
        P [varDeclaration] 
        [makeLambdaWithType] 
        [makeLambda] 
        [stringConcat]
        [makeIf]
        [makeCase]
        [makeBranch]
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

rule makeIf 
    replace [ife]
        'if  '( Cond [expression] ') 'then Exp1 [expression] 'else Exp2 [expression]
    by
        'if '( Cond ') '{
             Exp1 
             '} 'else '{ 
                 Exp2 
                 '}
    end rule 

rule makeCase
    replace [cases]
        'case Exp [expression] '{ Branche [branches] MoreBranches [repeat branches] '}
    by
    switch '( Exp ') '{
        
            Branche 
    
            MoreBranches
    '}
end rule

rule makeBranch 
    replace [branches]
        'of Exp [expression] => Exp2 [expression]  BrancheOpt [opt branches]
    by
        'case Exp : Exp2 break;

        BrancheOpt
end rule    

rule test
    replace [number]
        15
    by
        37
end rule

