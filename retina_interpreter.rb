#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 4 - Interpreter
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#               - Edwar Yepez       12-10855
#

require_relative 'runtime_errors'

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
		
		when Comp_expr_node
			comp_expr_interpreter(instr, symbolTable)
		
		#when Callfunc_node
		#	callfunc_interpreter(instr, symbolTable)
		#
		when Assignop_node
			assignop_interpreter(instr, symbolTable)
		
		when Withblk_node
			withblk_interpreter(instr)
		
		when While_loop_node
			while_loop_interpreter(instr, symbolTable)
		
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
		
		when Comp_expr_node
			return comp_expr_interpreter(expr, symbolTable)
		
		#when Callfunc_node
		#	return callfunc_interpreter(expr, symbolTable)
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
	
	def comp_expr_interpreter(instr, symbolTable)
		# Value of left side of expression
		leftValue = expr_interpreter(instr.left, symbolTable)
		# Value of right side of expression
		rightValue = expr_interpreter(instr.right, symbolTable)
		
		# Operator of expression
		op = instr.op
	
		if(op.eql? "EQUALITY") then
			return (leftValue == rightValue)

		elsif(op.eql? "INEQUALITY") then
			return (leftValue != rightValue)

		elsif(op.eql? "GREATHER THAN") then
			return (leftValue > rightValue)

		elsif(op.eql? "GREATHER THAN OR EQUAL") then
			return (leftValue >= rightValue)

		elsif(op.eql? "LESS THAN") then
			return (leftValue < rightValue)

		elsif(op.eql? "LESS THAN OR EQUAL") then
			return (leftValue <= rightValue)

		end
	end

	def assignop_interpreter(assignop, symbolTable)
		# Get identifier of variable
		identifier = assignop.ident.name.value
		
		# Get value of assigment expression
		exprValue = expr_interpreter(assignop.expr, symbolTable)

		# Store new value for variable in symbol table
		symbolTable.set_value(identifier, exprValue)
	end

	def withblk_interpreter(withblk)
		# Get symbol table for with-do block scope
		symbolTable = withblk.symbolTable

		# Store initializations in variable declarations
		declist_interpreter(withblk.declist, symbolTable)

		# Interpret with-do instruction block
		instrlist_interpreter(withblk.instrlist, symbolTable)
	end

	def declist_interpreter(declist, symbolTable)
		# Interpret current declaration
		decl_interpreter(declist.nxt_decl, symbolTable) unless declist.nxt_decl.nil?
		
		# Interpret following declarations
		declist_interpreter(declist.decl, symbolTable) unless declist.decl.nil?

	end

	def decl_interpreter(decl, symbolTable)
		# Single declaration with assignment
		if(not decl.assign.nil?) then
			# Interpret assignment to variable
			assignop_interpreter(decl.assign, symbolTable)
		end
	end

	def while_loop_interpreter(whileblk, symbolTable)

		# Get value of boolean condition
		condValue = expr_interpreter(whileblk.expr, symbolTable)

		# While condition evaluates to true execute instruction block
		while(condValue) do

			puts "in"
			# Interpret instructions inside while block
			instrlist_interpreter(whileblk.instrlist, symbolTable)
		
			# Evaluate conditional expression
			condValue = expr_interpreter(whileblk.expr, symbolTable)
		end

		puts "out"
	end
end