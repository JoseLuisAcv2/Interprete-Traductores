#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 2 - AST
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#

class AST_node;
    def indent(ind)
        for i in 1..ind
            print "\t"
        end
    end
end

class Instruction_node < AST_node;end
class Expression_node < AST_node;end
class Bin_expr_node < AST_node;end
class Un_expr_node < AST_node;end

class S_node < AST_node
    def initialize(defblk = nil, programblk = nil)
        @ind = 0
        @defblk = defblk
        @programblk = programblk
    end

    def print_ast
        if not @defblk.nil? then
            puts "FUNCTION DEFINITION BLOCK:"
            puts
            @defblk.print_ast(@ind+1)
        end
        @programblk.print_ast(@ind) unless @programblk.nil?        
    end
end

class Programblk_node < AST_node
    def initialize(instrlist)
        @instrlist = instrlist
    end

    def print_ast(ind)
        indent(ind)
        puts "PROGRAM:"
        @instrlist.print_ast(ind+1)
    end
end

class Defblk_node < AST_node
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

class Funcdef_node < Instruction_node
    def initialize(ident, paramlist, type, instrlist)
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

class Identifier_node < Expression_node
    def initialize(name)
        @name = name
    end

    def print_ast(ind)
        indent(ind)
        puts "IDENTIFIER: #{@name.value}"
    end
end

class Boolean_node < Expression_node
    def initialize(value)
        @value = value
    end

    def print_ast(ind)
        indent(ind)
        puts "BOOLEAN LITERAL: #{@value.value}"
    end
end

class Number_node < Expression_node
    def initialize(value)
        @value = value
    end

    def print_ast(ind)
        indent(ind)
        puts "NUMERICAL LITERAL: #{@value.value}"
    end
end

class String_node < Expression_node
    def initialize(value)
        @value = value
    end

    def print_ast(ind)
        indent(ind)
        puts "STRING: #{@value.value}"
    end
end

class Paramlist_node < AST_node
    def initialize(param, paramlist)
        @param = param
        @paramlist = paramlist
    end

    def print_ast(ind)
        @param.print_ast(ind)
        @paramlist.print_ast(ind) unless @paramlist.nil?
    end
end

class Param_node < AST_node
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

class Type_node < AST_node
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

class Instrlist_node < AST_node
    def initialize(nxt_instr, instr)
        @nxt_instr = nxt_instr
        @instr = instr
    end

    def print_ast(ind)
        @nxt_instr.print_ast(ind) unless @nxt_instr.nil?
        @instr.print_ast(ind) unless @instr.nil?
    end
end

class Return_node < Instruction_node
    def initialize(expr)
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

class Logical_bin_expr_node < Bin_expr_node;
    def initialize(left, right, op)
        @left = left
        @right = right
        @op = op
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

class Logical_un_expr_node < Un_expr_node;
    def initialize(operand, operator)
        @operand = operand
        @operator = operator
    end

    def print_ast(ind)
        indent(ind)
        puts "#{@operator}:"
        @operand.print_ast(ind+2)
    end
end

class Arith_bin_expr_node < Bin_expr_node;
    def initialize(left, right, op)
        @left = left
        @right = right
        @op = op
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

class Arith_un_expr_node < Un_expr_node;
    def initialize(operand, operator)
        @operand = operand
        @operator = operator
    end

    def print_ast(ind)
        indent(ind)
        puts "#{@operator}:"
        @operand.print_ast(ind+2)
    end
end

class Comp_expr_node < Bin_expr_node;
    def initialize(left, right, op)
        @left = left
        @right = right
        @op = op
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

class Callfunc_node < Expression_node
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

class Arglist_node < AST_node
    def initialize(arg, arglist)
        @arg = arg
        @arglist = arglist
    end

    def print_ast(ind)
        @arg.print_ast(ind)
        @arglist.print_ast(ind) unless @arglist.nil?
    end
end

class Assignop_node < Instruction_node
    def initialize(ident, expr)
        @ident = ident
        @expr = expr
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

class Withblk_node < Instruction_node
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

class Declist_node < AST_node
    def initialize(nxt_decl, decl)
        @nxt_decl = nxt_decl
        @decl = decl
    end

    def print_ast(ind)
        @nxt_decl.print_ast(ind) unless @nxt_decl.nil?
        @decl.print_ast(ind) unless @decl.nil?
    end
end

class Identlist_node < AST_node
    def initialize(nxt_ident, ident)
        @nxt_ident = nxt_ident
        @ident = ident
    end

    def print_ast(ind)
        @nxt_ident.print_ast(ind) unless @nxt_ident.nil?
        @ident.print_ast(ind) unless @ident.nil?
    end
end

class Decl_node < Instruction_node
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

class While_loop_node < Instruction_node
    def initialize(expr, instrlist)
        @expr = expr
        @instrlist = instrlist
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

class For_loop_node < Instruction_node
    def initialize(counter, lower_bound, upper_bound, increment, instrlist)
        @counter = counter
        @lower_bound = lower_bound
        @upper_bound = upper_bound
        @increment = increment
        @instrlist = instrlist
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

class For_loop_const_node < Instruction_node
    def initialize(counter, lower_bound, upper_bound, instrlist)
        @counter = counter
        @lower_bound = lower_bound
        @upper_bound = upper_bound
        @instrlist = instrlist
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

class Repeat_loop_node < Instruction_node
    def initialize(expr, instrlist)
        @expr = expr
        @instrlist = instrlist
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

class If_node < Instruction_node
    def initialize(cond, instrlist1, instrlist2)
        @cond = cond
        @instrlist1 = instrlist1
        @instrlist2 = instrlist2
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

class Write_node < Instruction_node
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

class Writelist_node < AST_node
    def initialize(nxt_write, cur_write)
        @nxt_write = nxt_write
        @cur_write = cur_write
    end

    def print_ast(ind)
        @nxt_write.print_ast(ind) unless @nxt_write.nil?
        @cur_write.print_ast(ind) unless @cur_write.nil?
    end
end

class Read_node < Instruction_node
    def initialize(ident)
        @ident = ident
    end

    def print_ast(ind)
        indent(ind)
        puts "READ FROM INPUT:"
        @ident.print_ast(ind+1)
    end
end