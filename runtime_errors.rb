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

	def initialize(token, errorType)
		@token = token
		@errorType = errorType
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
		end
	end

end