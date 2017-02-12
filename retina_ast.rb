#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 2 - AST
#
# 	Autores:
# 				- Jose Acevedo		13-10006
# 				- Edwar Yepez		12-10855
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

### FALTA
class Programblk_node < AST_node
    def initialize
    end

    def print_ast(ind)
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
        @defblk.print_ast unless @defblk.nil?
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
        @paramlist.print_ast(ind+2)
        indent(ind)
        puts "\tINSTRUCTION LIST:"
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