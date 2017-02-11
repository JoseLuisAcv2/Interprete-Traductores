class Parser

    prechigh
    
        nonassoc PRNTS
        right NOT UMINUS
        left MULT DIV MOD
        left PLUS MINUS
        nonassoc EQUALITYOP ORDEROP
        left AND
        left OR
        right ASSIGNOP
        left SEMICOLON

    preclow

    token   PROGRAM BEGINBLK ENDBLK WITH DO REPEAT TIMES READ WRITE WRITELN 
            IF THEN ELSE WHILE FOR FROM TO BY FUNC RETURN RETURNTYPE TYPE 
            EQUALITYOP ORDEROP LPARENTH RPARENTH ASSIGNOP SEP COLON 
            MINUS PLUS MULT DIV MOD AND OR NOT BOOLEAN NUMBER STRING IDENTIFIER 

    rule
        
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
        
        iter
        : WHILE expr DO instr ENDBLK 
        | FOR ident FROM expr TO expr BY expr DO instr ENDBLK
        | FOR ident FROM expr TO expr DO instr ENDBLK
        | REPEAT expr TIMES instr ENDBLK
        ;

        funciter
        : WHILE expr DO funcinstr ENDBLK 
        | FOR ident FROM expr TO expr BY expr DO funcinstr ENDBLK
        | FOR ident FROM expr TO expr DO funcinstr ENDBLK
        | REPEAT expr TIMES funcinstr ENDBLK
        ;

        cond
        : IF expr THEN instr ENDBLK
        | IF expr THEN instr ELSE instr ENDBLK
        ;

        funccond
        : IF expr THEN funcinstr ENDBLK
        | IF expr THEN funcinstr ELSE funcinstr ENDBLK
        ;

        instr
        : instr expr SEP
        | instr assign SEP
        | instr cond SEP
        | instr iter SEP
        | instr withblk SEP
        | instr readblk SEP
        | instr writeblk SEP
        | 
        ;

        funcinstr
        : funcinstr expr SEP
        | funcinstr assign SEP   
        | funcinstr funccond SEP
        | funcinstr funciter SEP
        | funcinstr funcwithblk SEP 
        | funcinstr returnblk SEP       
        |
        ;

        writeblk
        : WRITE writelist str
        | WRITE writelist expr
        | WRITELN writelist str
        | WRITELN writelist expr
        ;

        writelist
        : writelist str COLON
        | writelist expr COLON
        |
        ;

        readblk
        : READ ident
        ;

        callfunc
        : ident LPARENTH arglist RPARENTH
        | ident LPARENTH RPARENTH
        ;

        decl
        : TYPE identlist SEP
        | TYPE assign SEP
        ;

        paramlist
        : param COLON paramlist
        | param
        ;

        arglist
        : expr COLON arglist
        | expr
        ;

        identlist
        : ident COLON
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
        : expr AND expr
        | expr OR expr
        | NOT expr
        | expr EQUALITYOP expr
        | expr ORDEROP expr
        | expr MULT expr
        | expr DIV expr
        | expr MOD expr
        | expr PLUS expr
        | expr MINUS expr
        | MINUS expr =UMINUS
        | LPARENTH expr RPARENTH =PRNTS
        | b
        | n
        | ident
        | callfunc
        ;

        param
        : TYPE ident
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

require_relative "retina_lexer.rb"
require_relative "retina_ast.rb"

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        if @token.eql? "$" then
            "Unexpected EOF"
        else
            "Line #{@token.line}, column #{@token.column}: unexpected token #{@token.symbol}: #{@token.value}"   
        end
    end
end

---- inner

def initialize(lexer)
    @lexer = lexer
end

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end

def next_token
    if @lexer.has_next_token then
        token = @lexer.next_token;
        return [token.symbol,token]
    else
        return nil
    end
end

def parse
    do_parse
end