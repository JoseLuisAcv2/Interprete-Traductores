#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 4 - Interpreter
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#               - Edwar Yepez       12-10855
#

# Retina interpreter
class Interpreter

	def initialize(ast)
		@ast = ast
	end

	# Interpret AST
	def interpret()
		puts "testing interpreting... GOOD"
		raise RunTimeError.new
	end
end

# Handle Retina runtime errors
class RunTimeError < RuntimeError

	def initialize()
		
	end

	def to_s
		"testing runtime error... GOOD"
	end

end