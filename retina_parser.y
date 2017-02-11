class Parser

	token   PROGRAM BEGINBLK ENDBLK WITH DO REPEAT TIMES READ WRITE WRITELN 
            IF THEN ELSE WHILE FOR FROM TO BY FUNC RETURN RETURNTYPE TYPE 
            BOOLEAN BOP NOT EQUALITYOP ORDEROP LPARENTH RPARENTH ASSIGNOP 
            SEP COLON MINUS AOP NUMBER STRING IDENTIFIER

    #prechigh

    #preclow

start RETINA

rule
        
    RETINA
    : DEFBLOCK PROGRAMBLOCK
    | DEFBLOCK
    
    DEFBLOCK
    : DEF DEFBLOCK
    | 
    ;
    
    DEF
    : FUNC IDENT LPARENTH PARAMLIST RPARENTH BEGINBLK FUNCINSTR ENDBLK SEP
    | FUNC IDENT LPARENTH PARAMLIST RPARENTH RETURNTYPE TYPE BEGINBLK FUNCINSTR ENDBLK SEP
    | FUNC IDENT LPARENTH RPARENTH BEGINBLK FUNCINSTR ENDBLK SEP
    | FUNC IDENT LPARENTH RPARENTH BEGINBLK RETURNTYPE TYPE FUNCINSTR ENDBLK SEP
    ;
    
    FUNCINSTR
    : INSTR FUNCINSTR
    | FUNCCOND SEP FUNCINSTR
    | FUNCITER SEP FUNCINSTR
    | FUNCWITHBLOCK SEP FUNCINSTR 
    | RETURNEXPR SEP FUNCINSTR
    | 
    ;
    
    FUNCITER
    : WHILE BEXPR DO FUNCINSTR ENDBLK 
    | FOR IDENT FROM AEXPR TO AEXPR BY AEXPR DO FUNCINSTR ENDBLK
    | FOR IDENT FROM AEXPR TO AEXPR DO FUNCINSTR ENDBLK
    | REPEAT AEXPR TIMES FUNCINSTR ENDBLK
    ;
    
    FUNCCOND
    : IF BEXPR THEN FUNCINSTR ENDBLK
    | IF BEXPR THEN FUNCINSTR ELSE FUNCINSTR ENDBLK
    ;
    
    FUNCWITHBLOCK
    : WITH DECLBLOCK SEP DO FUNCINSTR ENDBLK
    ;
    
    CALLFUNC
    : IDENT LPARENTH TERMINALLIST RPARENTH
    | IDENT LPARENTH RPARENTH
    ;
    
    RETURNEXPR 
    : RETURN
    | RETURN EXPR
    ;
    
    PARAMLIST
    : PARAM COLON PARAMLIST
    | PARAM
    ;
    
    PARAM
    : TYPE IDENT
    ;
    
    PROGRAMBLOCK
    : PROGRAM INSTR ENDBLK SEP
    
    INSTR
    : EXPR SEP INSTR 
    | ASSIGN SEP INSTR
    | COND SEP INSTR
    | ITER SEP INSTR
    | READBLOCK SEP INSTR
    | WRITEBLOCK SEP INSTR
    | WITHBLOCK SEP INSTR
    | 
    ;
    
    EXPR
    : AEXPR
    | BEXPR
    ;
    
    AEXPR
    : AEXPR AOP AEXPR
    | AEXPR MINUS AEXPR
    | LPARENTH AEXPR RPARENTH
    | MINUS AEXPR
    | N
    | IDENT
    | CALLFUNC
    ;
    
    BEXPR
    : BEXPR BOP BEXPR
    | LPARENTH BEXPR RPARENTH
    | NOT BEXPR
    | EXPR EQUALITYOP EXPR
    | AEXPR ORDEROP AEXPR
    | B
    | IDENT
    | CALLFUNC
    ;
    
    READBLOCK
    : READ IDENT
    ;
    
    WRITEBLOCK
    : WRITE PRINTLIST
    | WRITELN PRINTLIST
    ;
    
    PRINTLIST
    : STRING COLON PRINTLIST
    | EXPR COLON PRINTLIST
    | STRING
    | EXPR
    ;
    
    DECLBLOCK
    : DECL DECLBLOCK
    |
    ;
    
    DECL
    : TYPE IDENTLIST SEP
    | TYPE ASSIGN SEP
    ;
    
    ASSIGN
    : IDENT ASSIGNOP EXPR
    ;
    
    IDENTLIST
    : IDENT COLON IDENTLIST
    | IDENT
    ;
    
    TERMINALLIST
    : B COLON TERMINALLIST
    | N COLON TERMINALLIST
    | IDENT COLON TERMINALLIST
    | B
    | N
    | IDENT
    ;
    
    COND
    : IF BEXPR THEN INSTR ENDBLK
    | IF BEXPR THEN INSTR ELSE INSTR ENDBLK
    ;
    
    ITER
    : WHILE BEXPR DO INSTR ENDBLK 
    | FOR IDENT FROM AEXPR TO AEXPR BY AEXPR DO INSTR ENDBLK
    | FOR IDENT FROM AEXPR TO AEXPR DO INSTR ENDBLK
    | REPEAT AEXPR TIMES INSTR ENDBLK
    ;
    
    WITHBLOCK
    : WITH DECLBLOCK SEP DO INSTR ENDBLK
    ;
    
    B
    : BOOLEAN
    ;
    
    N
    : NUMBER
    ;
    
    IDENT
    : IDENTIFIER
    ;   

end

---- header

require_relative "retina_lexer"
require_relative "retina_ast"

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        "Syntactic error on line #{@token.line}, column #{@token.column}: #{@token.value}"   
    end
end

---- inner

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end

def next_token
    if @lexer.has_next_token then
        token = @lexer.next_token;
        return [token.symbol,token]
    else
        return [false,false];
    end
end

def parse(lexer)
    @yydebug = true
    @lexer = lexer
    @tokens = []
    ast = do_parse
    return ast
end