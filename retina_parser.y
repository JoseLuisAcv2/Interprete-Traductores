class Parser


    prechigh
        
        nonassoc APRNTS BPRNTS
        nonassoc NOT
        nonassoc UMINUS
        left ARITHMETICOP
        left PLUS MINUS
        nonassoc ORDEROP
        right EQUALITYOP
        left BOOLEANOP
        right ASSIGNOP
        left SEMICOLON
    
    preclow

    token   PROGRAM BEGINBLK ENDBLK WITH DO REPEAT TIMES READ WRITE WRITELN 
            IF THEN ELSE WHILE FOR FROM TO BY FUNC RETURN RETURNTYPE TYPE 
            BOOLEAN BOOLEANOP NOT EQUALITYOP ORDEROP LPARENTH RPARENTH ASSIGNOP 
            SEP COLON MINUS PLUS ARITHMETICOP NUMBER STRING IDENTIFIER

    rule
        
        RETINA
        : DEFBLOCK PROGRAMBLOCK
        | DEFBLOCK
        ;
        
        PROGRAMBLOCK
        : PROGRAM INSTR ENDBLK SEP
        ;
 
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
        
        DECLBLOCK
        : DECL DECLBLOCK
        |
        ;

        WITHBLOCK
        : WITH DECLBLOCK SEP DO INSTR ENDBLK
        ;

        FUNCWITHBLOCK
        : WITH DECLBLOCK SEP DO FUNCINSTR ENDBLK
        ;
        
        WRITEBLOCK
        : WRITE PRINTLIST
        | WRITELN PRINTLIST
        ;

        READBLOCK
        : READ IDENT
        ;

        ITER
        : WHILE BEXPR DO INSTR ENDBLK 
        | FOR IDENT FROM AEXPR TO AEXPR BY AEXPR DO INSTR ENDBLK
        | FOR IDENT FROM AEXPR TO AEXPR DO INSTR ENDBLK
        | REPEAT AEXPR TIMES INSTR ENDBLK
        ;

        FUNCITER
        : WHILE BEXPR DO FUNCINSTR ENDBLK 
        | FOR IDENT FROM AEXPR TO AEXPR BY AEXPR DO FUNCINSTR ENDBLK
        | FOR IDENT FROM AEXPR TO AEXPR DO FUNCINSTR ENDBLK
        | REPEAT AEXPR TIMES FUNCINSTR ENDBLK
        ;

        COND
        : IF BEXPR THEN INSTR ENDBLK
        | IF BEXPR THEN INSTR ELSE INSTR ENDBLK
        ;

        FUNCCOND
        : IF BEXPR THEN FUNCINSTR ENDBLK
        | IF BEXPR THEN FUNCINSTR ELSE FUNCINSTR ENDBLK
        ;

        FUNCINSTR
        : INSTR FUNCINSTR
        | FUNCCOND SEP FUNCINSTR
        | FUNCITER SEP FUNCINSTR
        | FUNCWITHBLOCK SEP FUNCINSTR 
        | RETURNEXPR SEP FUNCINSTR
        | 
        ;

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

        CALLFUNC
        : IDENT LPARENTH TERMINALLIST RPARENTH
        | IDENT LPARENTH RPARENTH
        ;

        DECL
        : TYPE IDENTLIST SEP
        | TYPE ASSIGN SEP
        ;

        PRINTLIST
        : STR COLON PRINTLIST
        | EXPR COLON PRINTLIST
        ;

        PARAMLIST
        : PARAM COLON PARAMLIST
        | PARAM
        ;

        TERMINALLIST
        : TERMINAL COLON TERMINALLIST
        | TERMINAL
        ;

        IDENTLIST
        : IDENT COLON IDENTLIST
        | IDENT
        ;

        ASSIGN
        : IDENT ASSIGNOP EXPR
        ;

        RETURNEXPR 
        : RETURN
        | RETURN EXPR
        ;

        EXPR
        : AEXPR
        | BEXPR
        ;

        BEXPR
        : BEXPR BOOLEANOP BEXPR
        | LPARENTH BEXPR RPARENTH  =BPRNTS
        | NOT BEXPR
        | EXPR EQUALITYOP EXPR
        | AEXPR ORDEROP AEXPR
        | B
        | IDENT
        | CALLFUNC
        ;

        AEXPR
        : AEXPR ARITHMETICOP AEXPR
        | AEXPR PLUS AEXPR
        | AEXPR MINUS AEXPR
        | LPARENTH AEXPR RPARENTH   =APRNTS
        | MINUS AEXPR   =UMINUS
        | N
        | IDENT
        | CALLFUNC
        ;

        PARAM
        : TYPE IDENT
        ;

        TERMINAL
        : B
        | N
        | IDENT
        ;

        STR
        : STRING
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