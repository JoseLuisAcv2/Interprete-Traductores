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
        left COLON
        left SEMICOLON

    preclow

    token   PROGRAM BEGINBLK ENDBLK WITH DO REPEAT TIMES READ WRITE WRITELN 
            IF THEN ELSE WHILE FOR FROM TO BY FUNC RETURN RETURNTYPE TYPE 
            EQUALITYOP ORDEROP LPARENTH RPARENTH ASSIGNOP SEP COLON 
            MINUS PLUS MULT DIV MOD AND OR NOT BOOLEAN NUMBER STRING IDENTIFIER 
    rule

        r
        : retina
        ;
        
        S
        : defblk programblk             {result = S_node.new(val[0],val[1])}
        ;
        
        programblk
        : PROGRAM instr ENDBLK SEP      {result = Programblk_node.new()}
        ;
 
        defblk
        : funcdef defblk                {result = Defblk_node.new(val[0],val[1])}
        | 
        ;

        funcdef
        : FUNC ident LPARENTH paramlist RPARENTH BEGINBLK funcinstr ENDBLK SEP                      {result = Funcdef_node.new(val[1],val[3],Type_node.new(nil),val[6])}
        | FUNC ident LPARENTH paramlist RPARENTH RETURNTYPE datatype BEGINBLK funcinstr ENDBLK SEP  {result = Funcdef_node.new(val[1],val[3],val[6],val[8])}
        | FUNC ident LPARENTH RPARENTH BEGINBLK funcinstr ENDBLK SEP                                {result = Funcdef_node.new(val[1],nil,Type_node.new(nil),val[5])}
        | FUNC ident LPARENTH RPARENTH RETURNTYPE datatype BEGINBLK funcinstr ENDBLK SEP            {result = Funcdef_node.new(val[1],nil,val[5],val[7])}
        ;
        
        withblk
        : WITH declblk DO instr ENDBLK
        ;

        funcwithblk
        : WITH declblk DO funcinstr ENDBLK
        ;
        
        declblk
        : decl SEP declblk
        |
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
        : instr expr SEP                {result = Instrlist_node.new(val[0],val[1])}
        | instr assign SEP              {result = Instrlist_node.new(val[0],val[1])}
        | instr cond SEP                {result = Instrlist_node.new(val[0],val[1])}
        | instr iter SEP                {result = Instrlist_node.new(val[0],val[1])}
        | instr withblk SEP             {result = Instrlist_node.new(val[0],val[1])}
        | instr readblk SEP             {result = Instrlist_node.new(val[0],val[1])}
        | instr writeblk SEP            {result = Instrlist_node.new(val[0],val[1])}
        | instr SEP                     {result = Instrlist_node.new(val[0],nil)}
        |                               {result = Instrlist_node.new(nil,nil)}
        ;

        funcinstr
        : funcinstr expr SEP            {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr assign SEP          {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr funccond SEP        {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr funciter SEP        {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr funcwithblk SEP     {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr returnblk SEP       {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr SEP                 {result = Instrlist_node.new(val[0],nil)}
        |                               {result = Instrlist_node.new(nil,nil)}
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
        : datatype identlist
        | datatype assign
        ;

        paramlist
        : param COLON paramlist     {result = Paramlist_node.new(val[0],val[2])}
        | param                     {result = Paramlist_node.new(val[0],nil)}
        ;

        arglist
        : expr COLON arglist
        | expr
        ;

        identlist
        : ident COLON identlist
        | ident
        ;

        assign
        : ident ASSIGNOP expr
        ;

        returnblk
        : RETURN                       {result = Return_node.new(nil)}
        | RETURN expr                  {result = Return_node.new(val[0])}
        ;

        expr
        : expr AND expr                 {result = Expression_node.new(val[0],val[1],val[2])}
        | expr OR expr                  {result = Expression_node.new(val[0],val[1],val[2])}
        | NOT expr                      {result = Expression_node.new(val[0],val[1],val[2])}
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
        : datatype ident    {result = Param_node.new(val[0],val[1])}
        ;

        datatype
        : TYPE              {result = Type_node.new(val[0])}
        ;

        str
        : STRING            {result = String_node.new(val[0])}
        ;

        b
        : BOOLEAN           {result = Boolean_node.new(val[0])}
        ;

        n
        : NUMBER            {result = Number_node.new(val[0])}
        ;

        ident
        : IDENTIFIER        {result = Identifier_node.new(val[0])}
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