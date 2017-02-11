class Parser

    prechigh
    
        nonassoc APRNTS BPRNTS
        right NOT UMINUS
        left MULT DIV MOD
        left PLUS MINUS
        nonassoc EQUALITYOP ORDEROP
        left AND
        left OR
        right ASSIGNOP
        left COLON
        left SEMICOLON

    preclow

    token   PROGRAM BEGINBLK ENDBLK WITH DO REPEAT TIMES READ WRITE WRITELN 
            IF THEN ELSE WHILE FOR FROM TO BY FUNC RETURN RETURNTYPE TYPE 
            BOOLEAN OR AND NOT EQUALITYOP ORDEROP LPARENTH RPARENTH ASSIGNOP 
            SEP COLON MINUS PLUS ARITHMETICOP NUMBER STRING IDENTIFIER

    rule

        r
        : retina
        ;
        
        retina
        : defblk programblk
        | defblk
        ;
        
        programblk
        : PROGRAM instr ENDBLK SEP
        ;
 
        defblk
        : funcdef defblk
        | 
        ;

        funcdef
        : FUNC ident LPARENTH paramlist RPARENTH BEGINBLK funcinstr ENDBLK SEP
        | FUNC ident LPARENTH paramlist RPARENTH RETURNTYPE TYPE BEGINBLK funcinstr ENDBLK SEP
        | FUNC ident LPARENTH RPARENTH BEGINBLK funcinstr ENDBLK SEP
        | FUNC ident LPARENTH RPARENTH BEGINBLK RETURNTYPE TYPE funcinstr ENDBLK SEP
        ;
        
        declblk
        : decl declblk
        |
        ;

        withblk
        : WITH declblk SEP DO instr ENDBLK
        ;

        funcwithblk
        : WITH declblk SEP DO funcinstr ENDBLK
        ;
        
        writeblk
        : WRITE writelist
        | WRITELN writelist
        ;

        readblk
        : READ ident
        ;

        iter
        : WHILE bexpr DO instr ENDBLK 
        | FOR ident FROM aexpr TO aexpr BY aexpr DO instr ENDBLK
        | FOR ident FROM aexpr TO aexpr DO instr ENDBLK
        | REPEAT aexpr TIMES instr ENDBLK
        ;

        funciter
        : WHILE bexpr DO funcinstr ENDBLK 
        | FOR ident FROM aexpr TO aexpr BY aexpr DO funcinstr ENDBLK
        | FOR ident FROM aexpr TO aexpr DO funcinstr ENDBLK
        | REPEAT aexpr TIMES funcinstr ENDBLK
        ;

        cond
        : IF bexpr THEN instr ENDBLK
        | IF bexpr THEN instr ELSE instr ENDBLK
        ;

        funccond
        : IF bexpr THEN funcinstr ENDBLK
        | IF bexpr THEN funcinstr ELSE funcinstr ENDBLK
        ;

        funcinstr
        : instr funcinstr
        | funccond SEP funcinstr
        | funciter SEP funcinstr
        | funcwithblk SEP funcinstr 
        | returnblk SEP funcinstr
        | 
        ;

        instr
        : expr SEP instr 
        | assign SEP instr
        | cond SEP instr
        | iter SEP instr
        | readblk SEP instr
        | writeblk SEP instr
        | withblk SEP instr
        | 
        ;

        callfunc
        : ident LPARENTH termlist RPARENTH
        | ident LPARENTH RPARENTH
        ;

        decl
        : TYPE identlist SEP
        | TYPE assign SEP
        ;

        writelist
        : str COLON writelist
        | expr COLON writelist
        ;

        paramlist
        : param COLON paramlist
        | param
        ;

        termlist
        : terminal COLON termlist
        | terminal
        ;

        identlist
        : ident COLON identlist
        | ident
        ;

        assign
        : ident ASSIGNOP expr
        ;

        returnblk 
        : RETURN
        | RETURN expr
        ;

        expr
        : aexpr
        | bexpr
        ;

        bexpr
        : bexpr AND bexpr
        | bexpr OR bexpr
        | LPARENTH bexpr RPARENTH  =BPRNTS
        | NOT bexpr
        | expr EQUALITYOP expr
        | aexpr ORDEROP aexpr
        | b
        | ident
        | callfunc
        ;

        aexpr
        : aexpr ARITHMETICOP aexpr
        | aexpr PLUS aexpr
        | aexpr MINUS aexpr
        | LPARENTH aexpr RPARENTH   =APRNTS
        | MINUS aexpr   =UMINUS
        | n
        | ident
        | callfunc
        ;

        param
        : TYPE ident
        ;

        terminal
        : b
        | n
        | ident
        ;

        str
        : STRING
        ;

        b
        : BOOLEAN
        ;

        n
        : NUMBER
        ;

        ident
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