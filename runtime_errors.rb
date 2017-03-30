#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 4 - Interpreter
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#               - Edwar Yepez       12-10855
#

# Handle Retina runtime errors
class RunTimeError < RuntimeError

	def initialize(token, errorType, extraInfo = nil)
		@token = token
		@errorType = errorType
		@extraInfo = extraInfo
	end

	def to_s
		puts "RUNTIME ERROR:"

		case @errorType
		when "division by zero in integer division"
			"LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": Division by zero in integer division."
		
		when "division by zero in exact division"
			"LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": Division by zero in exact division."
		
		when "division by zero in integer modulo"
			"LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": Division by zero in integer modulo."
		
		when "division by zero in exact modulo"
			"LINE " + @token.op_token.line.to_s + ", COLUMN " + @token.op_token.column.to_s + ": Division by zero in exact modulo."
		
		when "invalid input"
			"LINE " + @token.ident.name.line.to_s + ", COLUMN " + @token.ident.name.column.to_s + ": Invalid input '" + @extraInfo.to_s + "'. Must be boolean or number."	
		
		when "input boolean type expected"
			"LINE " + @token.ident.name.line.to_s + ", COLUMN " + @token.ident.name.column.to_s + ": Expected boolean type from input for variable '" + @token.ident.name.value + "' and '" + @extraInfo.to_s + "' is of type number."
		
		when "input number type expected"
			"LINE " + @token.ident.name.line.to_s + ", COLUMN " + @token.ident.name.column.to_s + ": Expected number type from input for variable '" + @token.ident.name.value + "' and '" + @extraInfo.to_s + "' is of type boolean."
		end
	end

end