#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 2 - AST
#
# 	Autores:
# 				- Jose Acevedo		13-10006
# 				- Edwar Yepez		12-10855
#

class AST
    def print_ast indent=""
        puts "#{indent}#{self.class}:"

        attrs.each do |a|
            a.print_ast indent + "	" if a.respond_to? :print_ast
        end
    end

    def attrs
        instance_variables.map do |a|
            instance_variable_get a
        end
    end
end

class ReservedWord < AST
    attr_accessor :word

    def initialize w 
        @word = w
    end

    def print_ast indent=""
        puts "#{indent}#{self.class}: #{@word}"
    end
end

class DataType < AST
    attr_accessor :type

    def initialize t
        @type = t
    end

    def print_ast indent=""
        puts "#{indent}#{self.class}: #{@type}"
    end
end

class UnaryOperator < AST
	attr_accessor :operand

    def initialize op
        @operand = op
    end

    def print_ast indent=""
        puts "#{indent}#{self.class}: #{@operand}"
    end
end

class BinaryOperator < AST
    attr_accessor :left, :right

    def initialize lh, rh
        @left = lh
        @right = rh
    end

	def print_ast indent=""
        puts "#{indent}#{self.class}: #{@left} #{@right}"
    end
end

class Identifier < AST
    attr_accessor :name

    def initialize n
        @name = n
    end

    def print_ast indent=""
        puts "#{indent}#{self.class}: #{@name}"
    end
end

class Literal < AST
    attr_accessor :value

    def initialize v
        @value = v
    end

    def print_ast indent=""
        puts "#{indent}#{self.class}: #{@value}"
    end
end

class OpenRoundBracket < AST;end
class CloseRoundBracket < AST;end
class AssignmentOperator < AST;end
class Semicolon < AST;end

class Program < ReservedWord;end
class With < ReservedWord;end
class Do < ReservedWord;end
class Begin < ReservedWord;end
class End < ReservedWord;end
class Repeat < ReservedWord;end
class Times < ReservedWord;end
class Read < ReservedWord;end
class Write < ReservedWord;end
class Writeln < ReservedWord;end
class If < ReservedWord;end
class Then < ReservedWord;end
class Else < ReservedWord;end
class While < ReservedWord;end
class For < ReservedWord;end
class From < ReservedWord;end
class To < ReservedWord;end
class By < ReservedWord;end
class Func < ReservedWord;end
class Return < ReservedWord;end
class ReturnType < ReservedWord;end

class NumberType < DataType;end
class BooleanType < DataType;end

class LogicalUnaryOperator < UnaryOperator;end
class ArithmeticUnaryOperator < UnaryOperator;end

class LogicalBinaryOperator < BinaryOperator;end
class ArithmeticBinaryOperator < BinaryOperator;end
class ComparisonOperator < BinaryOperator;end

class LogicalNot < LogicalUnaryOperator;end

class LogicalAnd < LogicalBinaryOperator;end
class LogicalOr < LogicalBinaryOperator;end

class EqualOperator < ComparisonOperator;end
class NotEqualOperator < ComparisonOperator;end
class GreaterThanOperator < ComparisonOperator;end
class GreaterThanOrEqualOperator < ComparisonOperator;end
class LessThanOperator < ComparisonOperator;end
class LessThanOrEqualOperator < ComparisonOperator;end

class UnaryMinus < ArithmeticUnaryOperator;end

class Addition < ArithmeticBinaryOperator;end
class Subtraction < ArithmeticBinaryOperator;end
class Multiplication < ArithmeticBinaryOperator;end
class FloatDivison < ArithmeticBinaryOperator;end
class ExactModulo < ArithmeticBinaryOperator;end
class IntegerDivison < ArithmeticBinaryOperator;end
class IntegerModulo < ArithmeticBinaryOperator;end

class BooleanLiteral < Literal;end
class NumericalLiteral < Literal;end
class StringLiteral < Literal;end

class BooleanTrue < BooleanLiteral;end
class BooleanFalse < BooleanLiteral;end