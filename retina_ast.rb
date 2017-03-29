#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 2 - AST
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#               - Edwar Yepez       12-10855
#

# Superclass of any element that belong to the AST
class AST_node;
    def indent(ind)
        for i in 1..ind
            print "\t"
        end
    end
end

# Definition of basis types of node in the AST
class Instruction_node < AST_node;end
class Expression_node < AST_node;end
class Bin_expr_node < AST_node;end
class Un_expr_node < AST_node;end

# Definition of root node an print_ast method
class S_node < AST_node

    attr_accessor :defblk, :programblk

    def initialize(defblk = nil, programblk = nil)
        @ind = 0
        @defblk = defblk
        @programblk = programblk
    end

    def print_ast
        puts "ABSTRACT SYNTAX TREE"
        puts ""
        if not @defblk.nil? then
            puts "FUNCTION DEFINITION BLOCK:"
            puts
            @defblk.print_ast(@ind+1)
        end
        @programblk.print_ast(@ind) unless @programblk.nil?        
    end
end

# Definition of a program block node
class Programblk_node < AST_node

    attr_accessor :instrlist, :symbolTable

    def initialize(instrlist)
        @instrlist = instrlist
    end

    def print_ast(ind)
        indent(ind)
        puts "PROGRAM:"
        @instrlist.print_ast(ind+1)
    end
end

# Definition of a definitions block node
class Defblk_node < AST_node
    
    attr_accessor :defblk, :funcdef

    def initialize(funcdef, defblk)
        @funcdef = funcdef
        @defblk = defblk
    end

    def print_ast(ind)
        @funcdef.print_ast(ind)
        puts
        @defblk.print_ast(ind) unless @defblk.nil?
    end
end

# Definition of a function declaration node
class Funcdef_node < Instruction_node

    attr_accessor :func, :ident, :paramlist, :type, :instrlist, :symbolTable

    def initialize(func, ident, paramlist, type, instrlist)
        @func = func
        @ident = ident
        @paramlist = paramlist
        @type = type
        @instrlist = instrlist
    end

    def print_ast(ind)
        indent(ind)
        puts "FUNCTION DEFINITION:"
        @ident.print_ast(ind+1)
        @type.print_ast(ind+1)
        indent(ind)
        puts "\tPARAMETER LIST:"
        @paramlist.print_ast(ind+2) unless @paramlist.nil?
        indent(ind)
        puts "\tINSTRUCTION BLOCK:"
        @instrlist.print_ast(ind+2)
    end
end

# Definition of identifier node
class Identifier_node < Expression_node

    attr_accessor :name

    def initialize(name)
        @name = name
    end

    def print_ast(ind)
        indent(ind)
        puts "IDENTIFIER: #{@name.value}"
    end
end

# Definition of a boolean node
class Boolean_node < Expression_node

    attr_accessor :value

    def initialize(value)
        @value = value
    end

    def print_ast(ind)
        indent(ind)
        puts "BOOLEAN LITERAL: #{@value.value}"
    end
end

# Definition of a number node
class Number_node < Expression_node

    attr_accessor :value

    def initialize(value)
        @value = value
    end

    def print_ast(ind)
        indent(ind)
        puts "NUMERICAL LITERAL: #{@value.value}"
    end
end

# Definition of a string node
class String_node < Expression_node

    attr_accessor :value

    def initialize(value)
        @value = value
    end

    def print_ast(ind)
        indent(ind)
        puts "STRING: #{@value.value}"
    end
end

# Definition of a parameters list node
class Paramlist_node < AST_node

    attr_accessor :param, :paramlist

    def initialize(param, paramlist)
        @param = param
        @paramlist = paramlist
    end

    def print_ast(ind)
        @param.print_ast(ind) unless @param.nil?
        @paramlist.print_ast(ind) unless @paramlist.nil?
    end
end

# Definition of a parameter node
class Param_node < AST_node

    attr_accessor :type, :ident

    def initialize(type, ident)
        @type = type
        @ident = ident
    end

    def print_ast(ind)
        indent(ind)
        puts "PARAMETER:"
        @type.print_ast(ind+1)
        @ident.print_ast(ind+1)
    end
end

# Definition of a type node
class Type_node < AST_node

    attr_accessor :type

    def initialize(type)
        @type = type
    end

    def print_ast(ind)
        indent(ind)
        print "TYPE: "
        if @type.nil? then
            puts "Not specified"
        else
            puts "#{@type.value}"
        end
    end
end

# Definition of a instruction list node
class Instrlist_node < AST_node

    attr_accessor :nxt_instr, :instr

    def initialize(nxt_instr, instr)
        @nxt_instr = nxt_instr
        @instr = instr
    end

    def print_ast(ind)
        @nxt_instr.print_ast(ind) unless @nxt_instr.nil?
        @instr.print_ast(ind) unless @instr.nil?
    end
end

# Definition of a return node
class Return_node < Instruction_node

    attr_accessor :ret, :expr

    def initialize(ret, expr = nil)
        @ret = ret
        @expr = expr
    end

    def print_ast(ind)
        indent(ind)
        puts "FUNCTION RETURN:"
        if @expr.nil? then
            indent(ind+1)
            puts "Void"
        else
            @expr.print_ast(ind+1)
        end
    end
end

# Definition of a logical binary expression node
class Logical_bin_expr_node < Bin_expr_node;

    attr_accessor :left, :right, :op, :op_token

    def initialize(left, right, op, op_token = nil)
        @left = left
        @right = right
        @op = op
        @op_token = op_token
    end

    def print_ast(ind)
        indent(ind)
        puts "#{@op}:"
        indent(ind+1)
        puts "LEFT SIDE:"
        @left.print_ast(ind+2)
        indent(ind+1)
        puts "RIGHT SIDE:"
        @right.print_ast(ind+2)
    end
end

# Definition of a unary logical expression node
class Logical_un_expr_node < Un_expr_node;

    attr_accessor :operand, :operator, :op_token

    def initialize(operand, operator, op_token)
        @operand = operand
        @operator = operator
        @op_token = op_token
    end

    def print_ast(ind)
        indent(ind)
        puts "#{@operator}:"
        indent(ind+1)
        puts "OPERAND:"
        @operand.print_ast(ind+2)
    end
end

# Definition of a arithmethic binary expression node
class Arith_bin_expr_node < Bin_expr_node;

    attr_accessor :left, :right, :op, :op_token

    def initialize(left, right, op, op_token)
        @left = left
        @right = right
        @op = op
        @op_token = op_token
    end

    def print_ast(ind)
        indent(ind)
        puts "#{@op}:"
        indent(ind+1)
        puts "LEFT SIDE:"
        @left.print_ast(ind+2)
        indent(ind+1)
        puts "RIGHT SIDE:"
        @right.print_ast(ind+2)
    end
end

# Definition of a arithmethic unary expression node
class Arith_un_expr_node < Un_expr_node;

    attr_accessor :operand, :operator, :op_token

    def initialize(operand, operator, op_token)
        @operand = operand
        @operator = operator
        @op_token = op_token
    end

    def print_ast(ind)
        indent(ind)
        puts "#{@operator}:"
        indent(ind+1)
        puts "OPERAND:"
        @operand.print_ast(ind+2)
    end
end

# Definition of a comparator expression node
class Comp_expr_node < Bin_expr_node;

    attr_accessor :left, :right, :op, :op_token 

    def initialize(left, right, op, op_token)
        @left = left
        @right = right
        @op = op
        @op_token = op_token
    end

    def print_ast(ind)
        indent(ind)
        puts "#{@op}:"
        indent(ind+1)
        puts "LEFT SIDE:"
        @left.print_ast(ind+2)
        indent(ind+1)
        puts "RIGHT SIDE:"
        @right.print_ast(ind+2)
    end
end

# Definition of a function call node
class Callfunc_node < Expression_node

    attr_accessor :ident, :arglist

    def initialize(ident, arglist)
        @ident = ident
        @arglist = arglist
    end

    def print_ast(ind)
        indent(ind)
        puts "FUNCTION CALL:"
        @ident.print_ast(ind+1)
        indent(ind+1)
        puts "ARGUMENT LIST:"
        if @arglist.nil? then
            indent(ind+2)
            puts "Empty"
        else
            @arglist.print_ast(ind+2)
        end
    end
end

# Definition of a argument list node
class Arglist_node < AST_node

    attr_accessor :arg, :arglist

    def initialize(arg, arglist)
        @arg = arg
        @arglist = arglist
    end

    def print_ast(ind)
        @arg.print_ast(ind)
        @arglist.print_ast(ind) unless @arglist.nil?
    end
end

# Definition of a assign instruction node
class Assignop_node < Instruction_node
    
    attr_accessor :ident, :expr, :op_token

    def initialize(ident, expr, op_token)
        @ident = ident
        @expr = expr
        @op_token = op_token
    end

    def print_ast(ind)
        indent(ind)
        puts "ASSIGNMENT:"
        indent(ind+1)
        puts "LEFT SIDE:"
        @ident.print_ast(ind+2)
        indent(ind+1)
        puts "RIGHT SIDE:"
        @expr.print_ast(ind+2)
    end
end

# Definition of a with-do block node
class Withblk_node < Instruction_node

    attr_accessor :declist, :instrlist, :symbolTable

    def initialize(declist, instrlist)
        @declist = declist
        @instrlist = instrlist
    end

    def print_ast(ind)
        indent(ind)
        puts "WITH-DO BLOCK:"
        indent(ind+1)
        puts "DECLARATION BLOCK:"
        @declist.print_ast(ind+2)
        indent(ind+1)
        puts "INSTRUCTION BLOCK:"
        @instrlist.print_ast(ind+2)

    end
end

# Definition of a declarations list node
class Declist_node < AST_node

    attr_accessor :decl, :nxt_decl

    def initialize(nxt_decl, decl)
        @nxt_decl = nxt_decl
        @decl = decl
    end

    def print_ast(ind)
        @nxt_decl.print_ast(ind) unless @nxt_decl.nil?
        @decl.print_ast(ind) unless @decl.nil?
    end
end

# Definition of an identifier list node
class Identlist_node < AST_node

    attr_accessor :ident, :nxt_ident

    def initialize(nxt_ident, ident)
        @nxt_ident = nxt_ident
        @ident = ident
    end

    def print_ast(ind)
        @nxt_ident.print_ast(ind) unless @nxt_ident.nil?
        @ident.print_ast(ind) unless @ident.nil?
    end
end

# Definition of a declaration node
class Decl_node < Instruction_node

    attr_accessor :type, :assign, :identlist

    def initialize(type, assign, identlist)
        @type = type
        @assign = assign
        @identlist = identlist
    end

    def print_ast(ind)
        indent(ind)
        puts "DECLARATION:"
        @type.print_ast(ind+1)
        if @assign.nil? then
            indent(ind+1)
            puts "IDENTIFIER LIST:"
            @identlist.print_ast(ind+2)
        else
            @assign.print_ast(ind+1)
        end
    end
end

# Definition of a while node
class While_loop_node < Instruction_node

    attr_accessor :expr, :instrlist, :whileTkn

    def initialize(expr, instrlist, whileTkn)
        @expr = expr
        @instrlist = instrlist
        @whileTkn = whileTkn
    end

    def print_ast(ind)
        indent(ind)
        puts "WHILE LOOP:"
        indent(ind+1)
        puts "CONDITION:"
        @expr.print_ast(ind+2)
        indent(ind+1)
        puts "INSTRUCTION BLOCK:"
        @instrlist.print_ast(ind+2)
    end
end

# Definition of a for node
class For_loop_node < Instruction_node

    attr_accessor :counter, :lower_bound, :upper_bound, :increment, :instrlist, :forTkn, :symbolTable

    def initialize(counter, lower_bound, upper_bound, increment, instrlist, forTkn)
        @counter = counter
        @lower_bound = lower_bound
        @upper_bound = upper_bound
        @increment = increment
        @instrlist = instrlist
        @forTkn = forTkn
    end

    def print_ast(ind)
        indent(ind)
        puts "FOR LOOP:"
        indent(ind+1)
        puts "COUNTER:"
        @counter.print_ast(ind+2)
        indent(ind+1)
        puts "LOWER BOUND:"
        @lower_bound.print_ast(ind+2)
        indent(ind+1)
        puts "UPPER BOUND:"
        @upper_bound.print_ast(ind+2)
        indent(ind+1)
        puts "INCREMENT:"
        @increment.print_ast(ind+2)
        indent(ind+1)
        puts "INSTRUCTION BLOCK:"
        @instrlist.print_ast(ind+2)
    end
end

# Definition of a for with increment node
class For_loop_const_node < Instruction_node

    attr_accessor :counter, :lower_bound, :upper_bound, :instrlist, :forTkn, :symbolTable

    def initialize(counter, lower_bound, upper_bound, instrlist, forTkn)
        @counter = counter
        @lower_bound = lower_bound
        @upper_bound = upper_bound
        @instrlist = instrlist
        @forTkn = forTkn
    end

    def print_ast(ind)
        indent(ind)
        puts "FOR LOOP WITH CONSTANT INCREMENT:"
        indent(ind+1)
        puts "COUNTER:"
        @counter.print_ast(ind+2)
        indent(ind+1)
        puts "LOWER BOUND:"
        @lower_bound.print_ast(ind+2)
        indent(ind+1)
        puts "UPPER BOUND:"
        @upper_bound.print_ast(ind+2)
        indent(ind+1)
        puts "INSTRUCTION BLOCK:"
        @instrlist.print_ast(ind+2)
    end
end

# Definition of a repeat node
class Repeat_loop_node < Instruction_node

    attr_accessor :expr, :instrlist, :rpTkn

    def initialize(expr, instrlist, rpTkn)
        @expr = expr
        @instrlist = instrlist
        @rpTkn = rpTkn
    end

    def print_ast(ind)
        indent(ind)
        puts "REPEAT LOOP:"
        indent(ind+1)
        puts "ITERATIONS:"
        @expr.print_ast(ind+2)
        indent(ind+1)
        puts "INSTRUCTION BLOCK:"
        @instrlist.print_ast(ind+2)
    end
end

# Definition of a conditional node
class If_node < Instruction_node

    attr_accessor :cond, :instrlist1, :instrlist2, :if

    def initialize(cond, instrlist1, instrlist2, ifs)
        @cond = cond
        @instrlist1 = instrlist1
        @instrlist2 = instrlist2
        @if = ifs
    end

    def print_ast(ind)
        indent(ind)
        puts "IF STATEMENT:"
        indent(ind+1)
        puts "CONDITION:"
        @cond.print_ast(ind+2)
        indent(ind+1)
        puts "INSTRUCTION BLOCK:"
        @instrlist1.print_ast(ind+2)
        if not @instrlist2.nil? then
            indent(ind+1)
            puts "ELSE INSTRUCTION BLOCK:"
            @instrlist2.print_ast(ind+2)
        end
    end
end

# Definition of a write node
class Write_node < Instruction_node

    attr_accessor :writelist, :lastitem

    def initialize(writelist, lastitem, newline = false)
        @writelist = writelist
        @lastitem = lastitem
        @newline = newline
    end

    def print_ast(ind)
        indent(ind)
        if @newline then
            puts "WRITE TO OUTPUT WITH NEWLINE:"
        else
            puts "WRITE TO OUTPUT:"
        end
        indent(ind+1)
        puts "EXPRESSIONS:"
        @writelist.print_ast(ind+2)
        @lastitem.print_ast(ind+2)
    end
end

# Definition of a write list node
class Writelist_node < AST_node

    attr_accessor :nxt_write, :cur_write

    def initialize(nxt_write, cur_write)
        @nxt_write = nxt_write
        @cur_write = cur_write
    end

    def print_ast(ind)
        @nxt_write.print_ast(ind) unless @nxt_write.nil?
        @cur_write.print_ast(ind) unless @cur_write.nil?
    end
end

# Definition of a read node
class Read_node < Instruction_node

    attr_accessor :ident

    def initialize(ident)
        @ident = ident
    end

    def print_ast(ind)
        indent(ind)
        puts "READ FROM INPUT:"
        @ident.print_ast(ind+1)
    end
end