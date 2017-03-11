#   Traductores e Interpretadores CI-3725
#   
#   Proyecto Fase 3 - Semantic Errors
#
#   Autores:
#               - Jose Acevedo      13-10006
#               - Edwar Yepez       12-10855
#

class SemanticError < RuntimeError

    def initialize(tok, errorType, extraInfo = nil)
        @token = tok
        @errorType = errorType
        @extraInfo = extraInfo
    end

    def to_s
    	puts "SEMANTIC ERROR FOUND:"

    	# Print message according to error type
    	case @errorType
    	when "function id not unique"
    		"LINE " + @token.func.line.to_s + ", COLUMN " + @token.func.column.to_s + ": function '" + @token.ident.name.value.to_s + "' already declared."
    	
    	when "parameter id not unique"
    		"LINE " + @extraInfo[0].func.line.to_s + ": parameter identifier '" + @token.ident.name.value.to_s + "' not unique in function '" + @extraInfo[0].ident.name.value.to_s + "'."
    	
    	when "variable not declared"
            "LINE " + @token.name.line.to_s + ": variable '" + @token.name.value.to_s + "' not declared."
        
        when "return type doesnt match function type"
            "LINE " + @token.ret.line.to_s + ": Return value type does not match the function type. Expected '" + @extraInfo[0] + "' type but '" + @extraInfo[1] + "' type found."

        when "empty return instruction in non-void function"
            "LINE " + @token.ret.line.to_s + ": Return value type does not match the function type. Expected '" + @extraInfo + "' type but 'void' found."

        when "return instruction in void function"
            "LINE " + @token.ret.line.to_s + ": Non-void return statement in void type function '" + @extraInfo + "'."
      
        when "return instruction not found in non-void function"
            "LINE " + @token.func.line.to_s + ": Missing return statement in function '" + @token.ident.name.value.to_s + "'."
        
        when "logical bin expr operand types are not boolean"
            "LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": '" + @token.op_token.value + "' operator can only be applied to boolean expressions."
        
        when "logical un expr operand type is not boolean"
            "LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": 'not' operator can only be applied to boolean expressions."

        when "arith bin expr operand types are not number"
            "LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": '" + @token.op_token.value + "' operator can only be applied to number expressions."
        
        when "arith un expr operand type is not number"
            "LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": '-' operator can only be applied to number expressions."

        when "equality comp expr operand types are not equal"
            "LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": '" + @token.op_token.value + "' comparator can only be applied to expressions of the same type."

        when "order comp expr operand types are not numbers"
            "LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": '" + @token.op_token.value + "' comparator can only be applied to number expressions."
            
        when "function not declared"
    		"LINE " + @token.ident.name.line.to_s + ", COLUMN " + @token.ident.name.column.to_s + ": function '" + @token.ident.name.value.to_s + "' not declared."

    	when "function call not enough arguments"
            "LINE " + @token.ident.name.line.to_s + ", COLUMN " + @token.ident.name.column.to_s + ": not enough arguments for function '" + @token.ident.name.value.to_s + "', " + @extraInfo.to_s + " expected."

        when "function call too many arguments"
            "LINE " + @token.ident.name.line.to_s + ", COLUMN " + @token.ident.name.column.to_s + ": too many arguments for function '" + @token.ident.name.value.to_s + "', " + @extraInfo.to_s + " expected."

        when "function call argument type mismatch"
            "LINE " + @token.ident.name.line.to_s + ", COLUMN " + @token.ident.name.column.to_s + ": argument " + (@extraInfo[0]+1).to_s + " for function '" + @token.ident.name.value.to_s + "' must be '" + @extraInfo[2] + "' but '" + @extraInfo[1] + "' expression given."

    	when "assign op variable and expression types are not equal"
            "LINE " + @token.op_token.line.to_s + ": cannot assign " + @extraInfo[1] + " expression to " + @extraInfo[0] + " variable."

    	when "variable id not unique in scope"
            "LINE " + @token.name.line.to_s + ", COLUMN " + @token.name.column.to_s + ": variable '" + @token.name.value + "' already declared."

    	when "if condition type not boolean"
            "LINE " + @token.if.line.to_s + ": if condition must be boolean."

        when "while condition type not boolean"
            "LINE " + @token.whileTkn.line.to_s + ": while condition must be boolean."

    	when "for lower bound type not number"
            "LINE " + @token.forTkn.line.to_s + ": for lower bound must be number."

        when "for upper bound type not number"
            "LINE " + @token.forTkn.line.to_s + ": for upper bound must be number."

        when "for increment type not number"
            "LINE " + @token.forTkn.line.to_s + ": for increment must be number."

        when "repeat expr type not number"
    		"LINE " + @token.rpTkn.line.to_s + ": repeat expression must be number."
    	end
    end
end