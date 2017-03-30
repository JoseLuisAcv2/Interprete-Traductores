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
		
		when Return_node
			return_interpreter(instr, symbolTable)
		
		when Logical_bin_expr_node
			logical_bin_expr_interpreter(instr, symbolTable)
		
		when Logical_un_expr_node
			logical_un_expr_interpreter(instr, symbolTable)
		
		when Arith_bin_expr_node
			arith_bin_expr_interpreter(instr, symbolTable)
		
		when Arith_un_expr_node
			arith_un_expr_interpreter(instr, symbolTable)
		
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

	# Return instructions
	def return_interpreter(instr, symbolTable)
		# void return instruction
		if(instr.expr.nil?) then
			return nil
		# return instruction with expression
		else
			return expr_interpreter(instr.expr, symbolTable)
		end
	end

	def boolean_interpreter(boolean)
		value =  boolean.value.value
		if(value == "true") then
			return true
		elsif(value == "false") then
			return false
		end
	end

	def number_interpreter(number)
		value = number.value.value.to_f
		return value
	end

	# Interpret identifier
	def identifier_interpreter(identifier, symbolTable)
		# Get identifier name
		name = identifier.name.value
		# Return value stored for this identifier
		return symbolTable.get_value(name)
	end

	def logical_bin_expr_interpreter(instr, symbolTable)
		# Left side boolean value
		leftValue = expr_interpreter(instr.left, symbolTable)
		# Right side boolean value
		rightValue = expr_interpreter(instr.right, symbolTable)

		# Boolean operator
		operator = instr.op

		if(operator.eql? "CONJUNCTION") then
			return (leftValue and rightValue)
		
		elsif (operator.eql? "DISJUNCTION") then
			return (leftValue or rightValue)
		end
	end

	def logical_un_expr_interpreter(instr, symbolTable)
		# Get value of boolean expression
		value = expr_interpreter(instr.operand, symbolTable)

		# Boolean operator
		operator = instr.operator

		if(operator.eql? "LOGICAL NEGATION") then
			return (not value)
		end
	end

	def arith_bin_expr_interpreter(instr, symbolTable)
		# Value of left side of expression
		leftValue = expr_interpreter(instr.left, symbolTable)
		# Value of right side of expression
		rightValue = expr_interpreter(instr.right, symbolTable)
	
		# Arithmetic operator
		op = instr.op

		if(op.eql? "ADDITION") then
			return (leftValue + rightValue)

		elsif(op.eql? "SUBTRACTION") then
			return (leftValue - rightValue)

		elsif(op.eql? "MULTIPLICATION") then
			return (leftValue * rightValue)
		
		elsif(op.eql? "INTEGER DIVISION") then
			if(rightValue.eql? 0.0) then
				raise RunTimeError.new instr, "division by zero in integer division"
			end
			return (leftValue / rightValue).truncate
		
		elsif(op.eql? "EXACT DIVISION") then
			if(rightValue.eql? 0.0) then
				raise RunTimeError.new instr, "division by zero in exact division"
			end
			return (leftValue / rightValue)
		
		elsif(op.eql? "INTEGER MODULO") then
			if(rightValue.eql? 0.0) then
				raise RunTimeError.new instr, "division by zero in integer modulo"
			end
			return (leftValue % rightValue).truncate
		
		elsif(op.eql? "EXACT MODULO") then
			if(rightValue.eql? 0.0) then
				raise RunTimeError.new instr, "division by zero in exact modulo"
			end
			return (leftValue % rightValue)
		end

	end

	def arith_un_expr_interpreter(instr, symbolTable)
		# Get value of arithmetic expression
		value = expr_interpreter(instr.operand, symbolTable)

		# Boolean operator
		operator = instr.operator
		
		if(operator.eql? "ARITHMETIC NEGATION") then
			return (-value)
		end
	end
	
	def expr_interpreter(expr, symbolTable)
		case expr
		when Number_node
			return number_interpreter(expr)
		
		when Boolean_node
			return boolean_interpreter(expr)
		
		when Identifier_node
			return identifier_interpreter(expr, symbolTable)
		
		when Logical_bin_expr_node
			return logical_bin_expr_interpreter(expr, symbolTable)
		
		when Logical_un_expr_node
			return logical_un_expr_interpreter(expr, symbolTable)
		
		when Arith_bin_expr_node
			return arith_bin_expr_interpreter(expr, symbolTable)
		
		when Arith_un_expr_node
			return arith_un_expr_interpreter(expr, symbolTable)
		
		#when Comp_expr_node
		#	return comp_expr_interpreter(expr, symbolTable)
		#
		#when Callfunc_node
		#	return callfunc_interpreter(expr, symbolTable)
		end
	end

end

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