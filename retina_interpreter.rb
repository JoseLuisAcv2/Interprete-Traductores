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
		scope_interpreter(@ast)
	end
	
	# Start interpreting AST	
	def scope_interpreter(scope)
		# Start interpreting main program block
		programblk_interpreter(scope.programblk)
	end
	
	# Interpret main program block
	def programblk_interpreter(programblk)
		instrlist_interpreter(programblk.instrlist, programblk.symbolTable)
	end

	# Interpret list of instructions
	def instrlist_interpreter(instrlist, symbolTable)
		# Interpret next instruction if exists
		instrlist_interpreter(instrlist.nxt_instr, symbolTable) unless instrlist.nxt_instr.nil?
		# Interpret current instruction if exists
		instr_interpreter(instrlist.instr, symbolTable) unless instrlist.instr.nil?
	end

	# Interpret single instruction
	def instr_interpreter(instr, symbolTable)
		case instr
		when Identifier_node
			identifier_interpreter(instr, symbolTable)
		
		#when Return_node
		#	return_interpreter(instr, symbolTable)
		#
		#when Logical_bin_expr_node
		#	logical_bin_expr_interpreter(instr, symbolTable)
		#
		#when Logical_un_expr_node
		#	logical_un_expr_interpreter(instr, symbolTable)
		#
		#when Arith_bin_expr_node
		#	arith_bin_expr_interpreter(instr, symbolTable)
		#
		#when Arith_un_expr_node
		#	arith_un_expr_interpreter(instr, symbolTable)
		#
		#when Comp_expr_node
		#	comp_expr_interpreter(instr, symbolTable)
		#
		#when Callfunc_node
		#	callfunc_interpreter(instr, symbolTable)
		#
		#when Assignop_node
		#	assignop_interpreter(instr, symbolTable)
		#
		#when Withblk_node
		#	withblk_interpreter(instr, symbolTable)
		#
		#when While_loop_node
		#	while_loop_interpreter(instr, symbolTable)
		#
		#when For_loop_node
		#	for_loop_interpreter(instr, symbolTable)
		#
		#when For_loop_const_node
		#	for_loop_const_interpreter(instr, symbolTable)
		#
		#when Repeat_loop_node
		#	repeat_loop_interpreter(instr, symbolTable)
		#
		#when If_node
		#	if_interpreter(instr, symbolTable)
		#
		#when Read_node
		#	read_interpreter(instr, symbolTable)
		#
		#when Write_node
		#	write_interpreter(instr, symbolTable)
		end
	end

	# Interpret identifier
	def identifier_interpreter(identifier, symbolTable)
		# Get identifier name
		name = identifier.name.value
		# Return value stored for this identifier
		return symbolTable.get_value(name)
	end
	






















	def return_interpreter
	
	end
	
	def logical_bin_expr_interpreter
	
	end
	
	def logical_un_expr_interpreter
	
	end
	
	def arith_bin_expr_interpreter
	
	end
	
	def arith_un_expr_interpreter
	
	end
	
	def comp_expr_interpreter
	
	end
	
	def callfunc_interpreter
	
	end
	
	def assignop_interpreter
	
	end
	
	def withblk_interpreter
	
	end
	
	def while_loop_interpreter
	
	end
	
	def for_loop_interpreter
	
	end
	
	def for_loop_const_interpreter
	
	end
	
	def repeat_loop_interpreter
	
	end
	
	def if_interpreter
	
	end
	
	def read_interpreter
	
	end
	
	def write_interpreter
	
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