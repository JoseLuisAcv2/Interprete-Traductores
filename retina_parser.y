#!/usr/bin/ruby
#
#   Traductores e Interpretadores CI-3725
#   
#   Proyecto Fase 2 - Context-Free Grammar for Retina
#
#   Autores:
#               - Jose Acevedo      13-10006
#               - Edwar Yepez       12-10855
#

class Parser

    # Precedence of tokens in Retina
    prechigh
    
        nonassoc PRNTS
        right NOT UMINUS
        left MULT DIV INTDIV MOD INTMOD
        left PLUS MINUS
        nonassoc EQOP INEQOP GTOP GEOP LTOP LEOP
        left AND
        left OR
        
    preclow

    # Valid Tokens list for Retina
    token   PROGRAM BEGINBLK ENDBLK WITH DO REPEAT TIMES READ WRITE WRITELN 
            IF THEN ELSE WHILE FOR FROM TO BY FUNC RETURN RETURNTYPE TYPE 
            EQOP INEQOP GTOP GEOP LTOP LEOP LPARENTH RPARENTH ASSIGNOP SEP COLON 
            MINUS PLUS MULT DIV INTDIV MOD INTMOD AND OR NOT BOOLEAN NUMBER STRING IDENTIFIER 
    
    # Definition of Context-free grammar that admit a Retina program
    rule
        
        # Initial rule. Defines the most general structure of Retina
        S
        : defblk programblk             {result = S_node.new(val[0],val[1])}
        | programblk                    {result = S_node.new(nil,val[0])}
        ;
        
        # Program Block: Defines the structure of Program Block in Retina
        programblk
        : PROGRAM instr ENDBLK SEP      {result = Programblk_node.new(val[1])}
        ;
 
        # Definitions Block. Defines the block that contains all functions
        # definitions in Retina
        defblk
        : funcdef defblk                {result = Defblk_node.new(val[0],val[1])}
        | funcdef                       {result = Defblk_node.new(val[0],nil)}
        ;

        # Function Definitions. Defines all possible structures of a valid
        # function definition in Retina
        funcdef
        : FUNC ident LPARENTH paramlist RPARENTH BEGINBLK funcinstr ENDBLK SEP                      {result = Funcdef_node.new(val[0], val[1],val[3],Type_node.new(nil),val[6])}
        | FUNC ident LPARENTH paramlist RPARENTH RETURNTYPE datatype BEGINBLK funcinstr ENDBLK SEP  {result = Funcdef_node.new(val[0], val[1],val[3],val[6],val[8])}
        | FUNC ident LPARENTH RPARENTH BEGINBLK funcinstr ENDBLK SEP                                {result = Funcdef_node.new(val[0], val[1],nil,Type_node.new(nil),val[5])}
        | FUNC ident LPARENTH RPARENTH RETURNTYPE datatype BEGINBLK funcinstr ENDBLK SEP            {result = Funcdef_node.new(val[0], val[1],nil,val[5],val[7])}
        ;
        
        # With-Do Block: Defines the structure of a with-do block in retina
        withblk
        : WITH declblk DO instr ENDBLK      {result = Withblk_node.new(val[1],val[3])}
        ;

        # Functions With-do block: Add previous with-do block the possibility of having a 
        # return instruction inside of do lists of instructions
        funcwithblk
        : WITH declblk DO funcinstr ENDBLK  {result = Withblk_node.new(val[1],val[3])}
        ;
       
        # Declarations Block: Defines the structure of a declarations block in retina
        declblk
        : decl SEP declblk                  {result = Declist_node.new(val[0],val[2])}
        |                                   {result = Declist_node.new(nil,nil)}
        ;

        # Iterators: Defines the structure of valid iterators in Retina
        iter
        : WHILE expr DO instr ENDBLK                                {result = While_loop_node.new(val[1],val[3],val[0])}
        | FOR ident FROM expr TO expr BY expr DO instr ENDBLK       {result = For_loop_node.new(val[1],val[3],val[5],val[7],val[9],val[0])}
        | FOR ident FROM expr TO expr DO instr ENDBLK               {result = For_loop_const_node.new(val[1],val[3],val[5],val[7],val[0])}
        | REPEAT expr TIMES instr ENDBLK                            {result = Repeat_loop_node.new(val[1],val[3],val[0])}
        ;

        # Function Iterators: Iterators that allow return instructions for functions in Retina
        funciter
        : WHILE expr DO funcinstr ENDBLK                            {result = While_loop_node.new(val[1],val[3],val[0])}
        | FOR ident FROM expr TO expr BY expr DO funcinstr ENDBLK   {result = For_loop_node.new(val[1],val[3],val[5],val[7],val[9],val[0])}
        | FOR ident FROM expr TO expr DO funcinstr ENDBLK           {result = For_loop_const_node.new(val[1],val[3],val[5],val[7],val[0])}
        | REPEAT expr TIMES funcinstr ENDBLK                        {result = Repeat_loop_node.new(val[1],val[3],val[0])}
        ;

        # Conditionals: Defines the structure of valid conditionals in Retina
        cond
        : IF expr THEN instr ENDBLK                                 {result = If_node.new(val[1],val[3],nil,val[0])}
        | IF expr THEN instr ELSE instr ENDBLK                      {result = If_node.new(val[1],val[3],val[5],val[0])}
        ;

        # Function Conditionals: Conditionals that allow return instructions for functions in Retina
        funccond
        : IF expr THEN funcinstr ENDBLK                             {result = If_node.new(val[1],val[3],nil,val[0])}
        | IF expr THEN funcinstr ELSE funcinstr ENDBLK              {result = If_node.new(val[1],val[3],val[5],val[0])}
        ;

        # Instructions: Defines the structure for all possible instructions in Retina
        instr
        : instr expr SEP                    {result = Instrlist_node.new(val[0],val[1])}
        | instr assign SEP                  {result = Instrlist_node.new(val[0],val[1])}
        | instr cond SEP                    {result = Instrlist_node.new(val[0],val[1])}
        | instr iter SEP                    {result = Instrlist_node.new(val[0],val[1])}
        | instr withblk SEP                 {result = Instrlist_node.new(val[0],val[1])}
        | instr readblk SEP                 {result = Instrlist_node.new(val[0],val[1])}
        | instr writeblk SEP                {result = Instrlist_node.new(val[0],val[1])}
        | instr SEP                         {result = Instrlist_node.new(val[0],nil)}
        |                                   {result = Instrlist_node.new(nil,nil)}
        ;

        # Function instructions: Defines the structures of all possible instructions inside
        # of a function in Retina
        funcinstr
        : funcinstr expr SEP                {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr assign SEP              {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr funccond SEP            {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr funciter SEP            {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr funcwithblk SEP         {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr readblk SEP             {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr writeblk SEP            {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr returnblk SEP           {result = Instrlist_node.new(val[0],val[1])}
        | funcinstr SEP                     {result = Instrlist_node.new(val[0],nil)}
        |                                   {result = Instrlist_node.new(nil,nil)}
        ;

        # Write block: Defines the structure of the output blocks in Retina
        writeblk
        : WRITE writelist str               {result = Write_node.new(val[1],val[2])}
        | WRITE writelist expr              {result = Write_node.new(val[1],val[2])}
        | WRITELN writelist str             {result = Write_node.new(val[1],val[2],true)}
        | WRITELN writelist expr            {result = Write_node.new(val[1],val[2],true)}
        ;

        # Write list: Defines the list of elements that can be printed in a write block
        writelist
        : writelist str COLON               {result = Writelist_node.new(val[0],val[1])}
        | writelist expr COLON              {result = Writelist_node.new(val[0],val[1])}
        |                                   {result = Writelist_node.new(nil,nil)}
        ;

        # Read Block: Defines the structure of a input block in Retina
        readblk
        : READ ident                        {result = Read_node.new(val[1])}
        ;

        # Functions calls: Defines the structure of a valid function call in Retina
        callfunc
        : ident LPARENTH arglist RPARENTH   {result = Callfunc_node.new(val[0],val[2])}
        | ident LPARENTH RPARENTH           {result = Callfunc_node.new(val[0],nil)}
        ;

        # Declarations: Defines valid declarations in Retina
        decl
        : datatype identlist                {result = Decl_node.new(val[0],nil,val[1])}
        | datatype assign                   {result = Decl_node.new(val[0],val[1],nil)}
        ;

        # Parameters list: Defines valid structure of list of parameters in a function
        # definition.
        paramlist
        : param COLON paramlist             {result = Paramlist_node.new(val[0],val[2])}
        | param                             {result = Paramlist_node.new(val[0],nil)}
        ;

        # Argument list: Defines valid structure of a list of arguments in a function call
        arglist
        : expr COLON arglist                {result = Arglist_node.new(val[0],val[2])}
        | expr                              {result = Arglist_node.new(val[0],nil)}
        ;

        # Identifiers list: Defines a valid structure for a list of identifiers in a declaration
        # instruction
        identlist
        : ident COLON identlist             {result = Identlist_node.new(val[0],val[2])}
        | ident                             {result = Identlist_node.new(val[0],nil)}
        ;

        # Assigns: Defines valid assignments in Retina
        assign
        : ident ASSIGNOP expr               {result = Assignop_node.new(val[0],val[2],val[1])}
        ;

        # Return Instruction: Defines valid return instructions in Retina
        returnblk
        : RETURN                            {result = Return_node.new(val[0],nil)}
        | RETURN expr                       {result = Return_node.new(val[0],val[1])}
        ;

        # Expressions: Defines the list of valid expressions in Retina
        expr
        : expr AND expr                     {result = Logical_bin_expr_node.new(val[0],val[2],'CONJUNCTION',val[1])}
        | expr OR expr                      {result = Logical_bin_expr_node.new(val[0],val[2],'DISJUNCTION',val[1])}
        | NOT expr                          {result = Logical_un_expr_node.new(val[1],'LOGICAL NEGATION',val[0])}
        | expr EQOP expr                    {result = Comp_expr_node.new(val[0],val[2],'EQUALITY',val[1])}
        | expr INEQOP expr                  {result = Comp_expr_node.new(val[0],val[2],'INEQUALITY',val[1])}
        | expr GTOP expr                    {result = Comp_expr_node.new(val[0],val[2],'GREATHER THAN',val[1])}
        | expr GEOP expr                    {result = Comp_expr_node.new(val[0],val[2],'GREATHER THAN OR EQUAL',val[1])}
        | expr LTOP expr                    {result = Comp_expr_node.new(val[0],val[2],'LESS THAN',val[1])}
        | expr LEOP expr                    {result = Comp_expr_node.new(val[0],val[2],'LESS THAN OR EQUAL',val[1])}
        | expr MULT expr                    {result = Arith_bin_expr_node.new(val[0],val[2],'MULTIPLICATION',val[1])}
        | expr DIV expr                     {result = Arith_bin_expr_node.new(val[0],val[2],'EXACT DIVISION',val[1])}
        | expr INTDIV expr                  {result = Arith_bin_expr_node.new(val[0],val[2],'INTEGER DIVISION',val[1])}
        | expr MOD expr                     {result = Arith_bin_expr_node.new(val[0],val[2],'EXACT MODULO',val[1])}
        | expr INTMOD expr                  {result = Arith_bin_expr_node.new(val[0],val[2],'INTEGER MODULO',val[1])}
        | expr PLUS expr                    {result = Arith_bin_expr_node.new(val[0],val[2],'ADDITION',val[1])}
        | expr MINUS expr                   {result = Arith_bin_expr_node.new(val[0],val[2],'SUBTRACTION',val[1])}
        | MINUS expr =UMINUS                {result = Arith_un_expr_node.new(val[1],'ARITHMETIC NEGATION',val[0])}
        | LPARENTH expr RPARENTH =PRNTS     {result = val[1]}
        | b                                 
        | n                                 
        | ident                             
        | callfunc                          
        ;

        # Parameter: Defines a valid parameter in a function definition
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
        puts "SYNTACTIC ERROR FOUND:"
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