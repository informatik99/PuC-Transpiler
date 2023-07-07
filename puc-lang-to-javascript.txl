include "transpiler-grammar.Grm"

function main 
    replace [program]
        P [program]
    by
        P 
        [makeLambdaWithType] 
        [makeLambda]
        [makeFunction]
        [varDeclaration]
        [stringConcat]
        [consoleOutput]
        [intNachString]
        [stringEquals]
        [makeIf]
        [makeCase]
        [makeBranch]
        [removeReturnOnVarDeclaration] 
        [removeReturnForNotEndReturn]
end function

 
rule stringConcat
    replace [string_concat] 
        String1 [atom] ++ StringConcat [expression]
    by
        String1 + StringConcat [helpStringConcat]
end rule

rule helpStringConcat
    replace [string_concat]
        String [atom] ++ String2 [atom]
    by
        String + String2
end rule


rule varDeclaration
    replace [var_declaration]
        let Variable [id] '= Expr1 [expression] in Expr2 [expression]
    by
        var Variable '= Expr1 Expr2 % Die Zeilenumbrüche müssen hier nicht stehen sondern in der .Grm Datei
end rule

% built-in überführen
rule consoleOutput
    replace [console_output]
        print '( Expr [end_return]')
    by
        '('(') => '{ console.log '( Expr ') return Expr '}') '(')
end rule

% built-in überführen
rule intNachString
    replace [int_nach_string]
        int_to_string'( Expr [end_return]')
    by
        String'( Expr ')
end rule

% built-in überführen
rule stringEquals
    replace [string_equals]
        str_eq'( Expr [end_return] ') '( Expr2 [end_return] ')
    by
        '( '( Wert1 ') => '{ return '( Wert2 ') => '{  return Wert1 == Wert2 '} '} ') '( Expr ') '( Expr2 ')
end rule


 % alles was sich speziell auf Funktionen bezieht ANFANG
rule varDeclarationForFunction
    replace [var_declaration]
        let Variable [id] '= Expr1 [expression] in Expr2 [expression]
    by
        var Variable '= Expr1 Expr2[putReturn] % Die Zeilenumbrüche müssen hier nicht stehen sondern in der .Grm Datei
end rule

rule ifElseForFunction
    replace [ife]
        'if  Cond [expression]  'then Expr1 [expression] else Expr2 [expression] 
    by
        'if '( Cond ') '{
             Expr1 [putReturn]
             '} 'else '{ 
                 Expr2 [putReturn]
                 '}
end rule

rule makeFunction
    replace [function_definition]
        def GenericType [generic_type_list] Name [id] '( ParameterList [function_parameter_list] ') : Type [type] => Expr [expression]
    by
        'function Name '( ParameterList [resolveParameterList] ') '{ return Expr  [ifElseForFunction] [varDeclarationForFunction]'}
end rule

% das Nonterminal function_parameter_list wird einfach übersprungen weil wir das Komma zwischen den Parametern nicht verarbeiten müssen
rule resolveParameterList
    replace [parameter_with_type]
        Name [id] : Type [type]
    by
        Name
end rule

rule makeLambda
    replace [lambda]
        fn Param [id] => Expr [expression]
    by
        '( Param ') => '{ return Expr [ifElseForFunction] [varDeclarationForFunction] '} 
end rule

rule makeLambdaWithType
    replace [lambda]
        fn Param [id] : Type [type] => Expr [expression]
    by
        '( Param ') => '{ return Expr [ifElseForFunction] [varDeclarationForFunction]  '}
end rule



% return hinschreiben um es nachher an den falschen Stellen wieder!
function putReturn
    replace * [expression]
        Expr [end_return] 
    by
        return Expr
end function


% hiermit das return an den falchen Stellen wieder entfernen!
function isVarDeclaration
    match * [var_declaration]
        V [var_declaration]
end function

function isIfElse
    match * [ife]
        I [ife]
end function

rule removeReturnForNotEndReturn
    replace [function_end]
        return Expr [expression]
    where 
        Expr [isVarDeclaration] [isIfElse]
    by
        Expr
end rule

function removeReturnOnVarDeclaration
    replace * [var_declaration]
        var V [id] '= return Expr1 [end_return] return Expr2 [end_return] 
    by 
        var V '= Expr1 [removeReturnOnVarDeclaration] return Expr2 [removeReturnOnVarDeclaration]
end function
 % alles was sich speziell auf Funktionen bezieht ENDE




rule makeIf 
    replace [ife]
        'if   Cond [expression] 'then Exp1 [expression] 'else Exp2 [expression]
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

