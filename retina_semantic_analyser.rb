#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 3 - Semantic Analyser
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#               - Edwar Yepez       12-10855
#

require_relative 'symbol_table'
require_relative 'semantic_errors'

$rootTable = SymbolTable.new "", "Root Table"
$funcTable = FuncSymbolTable.new  "Function Table"
$tableID = Array.new
$returnFound
$curFunction

# Semantic analyser for abstract syntax tree
class SemanticAnalyser

	def initialize(ast)
		@ast = ast
	end

	# Analyze AST
	def analyze()

		# Initialize table IDs
		$tableID.push(1)

		scope_handler(@ast)
		
		return $rootTable
	end

	# Handle entry point to AST
	def scope_handler(scope)

		# Store Retina pre-defined functions
		retinaFunc_handler()

		# Fuction definition block
		if not scope.defblk.nil? then
			defblk_handler(scope.defblk, $rootTable)
		end
		# Main program block
		programblk_handler(scope.programblk, $rootTable)
		$tableID.pop()

	end

	# Handle function definitions
	def defblk_handler(defblk, symbolTable)

		# Handle function
		funcdef_handler(defblk.funcdef, symbolTable)

		# Handle rest of functions
		if not defblk.defblk.nil? then
			defblk_handler(defblk.defblk, symbolTable)
		end

	end

	def funcdef_handler(funcdef, symbolTable)

		# Function identifier
		ident = funcdef.ident.name.value

		# Return type
		if(funcdef.type.type.nil?) then
			type = "void"
		else
			type = funcdef.type.type.value
		end

		# Store function in function table
		# Check function identifier uniqueness
		if(not $funcTable.has_key(ident)) then

			# Create new symbol table for function scope
			newSymbolTable = createSymbolTable(ident,symbolTable)

			# Store parameters in symbol table
			params = Array.new
			params = paramlist_handler(funcdef.paramlist, newSymbolTable, params) unless funcdef.paramlist.nil?

			# Insert function name with return type and parameters in functions table
			$funcTable.insert(ident,type,params)

		# Function identifier not unique
		else
			raise SemanticError.new funcdef, "function id not unique"
		end

		$curFunction = ident
		$returnFound = false
		instrlist_handler(funcdef.instrlist, newSymbolTable)

		if(not type.eql? "void" and $returnFound.eql? false) then
			raise SemanticError.new funcdef, "return instruction not found in non-void function"
		end

		$tableID.pop()

	end

	def paramlist_handler(paramlist, symbolTable, params)
		# Store parameter in function table
		param = param_handler(paramlist.param, symbolTable) unless paramlist.param.nil?
		params << param

		# Rest of parameters
		params = paramlist_handler(paramlist.paramlist, symbolTable, params) unless paramlist.paramlist.nil?
	
		return params

	end

	def param_handler(param, symbolTable)

		ident = param.ident.name.value
		type = param.type.type.value

		# Check parameter name uniqueness
		if(not symbolTable.has_key(ident)) then
			symbolTable.insert(ident,type)
		# Parameter identifier not unique
		else
			raise SemanticError.new param, "parameter id not unique"
		end

		return {"ident"=>ident, "type"=>type}

	end

	def instrlist_handler(instrlist, symbolTable)
		# Handle next instruction if exists
		instrlist_handler(instrlist.nxt_instr, symbolTable) unless instrlist.nxt_instr.nil?
		# Handle current instruction if exists
		instr_handler(instrlist.instr, symbolTable) unless instrlist.instr.nil?
	end

	def instr_handler(instr, symbolTable)
		case instr
		when Identifier_node
			identifier_handler(instr, symbolTable)
		
		when Return_node
			return_handler(instr, symbolTable)
		
		when Logical_bin_expr_node
			logical_bin_expr_handler(instr, symbolTable)
		
		when Logical_un_expr_node
			logical_un_expr_handler(instr, symbolTable)
		
		when Arith_bin_expr_node
			arith_bin_expr_handler(instr, symbolTable)
		
		when Arith_un_expr_node
			arith_un_expr_handler(instr, symbolTable)
		
		when Comp_expr_node
			comp_expr_handler(instr, symbolTable)
		
		when Callfunc_node
			callfunc_handler(instr, symbolTable)
		
		when Assignop_node
			assignop_handler(instr, symbolTable)
		
		when Withblk_node
			withblk_handler(instr, symbolTable)
		
		when While_loop_node
			while_loop_handler(instr, symbolTable)
		
		when For_loop_node
			for_loop_handler(instr, symbolTable)
		
		when For_loop_const_node
			for_loop_const_handler(instr, symbolTable)
		
		when Repeat_loop_node
			repeat_loop_handler(instr, symbolTable)
		
		when If_node
			if_handler(instr, symbolTable)
		
		when Read_node
			read_handler(instr, symbolTable)
		
		when Write_node
			write_handler(instr, symbolTable)
		end
	end

	def return_handler(instr, symbolTable)
		
		# Get function return type
		funcType = $funcTable.lookup($curFunction)

		# Return instruction without expression
		if(instr.expr.nil?) then
			# Error if function return type is number or boolean
			if(not funcType.eql? "void") then
				raise SemanticError.new funcType, "empty return instruction in non-void function"
			end			

		else	
			# Return instruction found
			$returnFound = true
	
			# Error if function return type is void
			if(funcType.eql? "void") then
				raise SemanticError.new funcType, "return instruction in void function"
			end
	
			# Get return expression type
			exprType = expr_handler(instr.expr, symbolTable)
	
			# Return type doesnt match function type
			if(not funcType.eql? exprType) then
				raise SemanticError.new exprType, "return type doesnt match function type"
			end
		end
	end

	def expr_handler(expr, symbolTable)
		case expr
		when Number_node
			return "number"
		
		when Boolean_node
			return "boolean"
		
		when Identifier_node
			return identifier_handler(expr, symbolTable)
		
		when Logical_bin_expr_node
			return logical_bin_expr_handler(expr, symbolTable)
		
		when Logical_un_expr_node
			return logical_un_expr_handler(expr, symbolTable)
		
		when Arith_bin_expr_node
			return arith_bin_expr_handler(expr, symbolTable)
		
		when Arith_un_expr_node
			return arith_un_expr_handler(expr, symbolTable)
		
		when Comp_expr_node
			return comp_expr_handler(expr, symbolTable)
		
		when Callfunc_node
			return callfunc_handler(expr, symbolTable)
		end
	end

	def identifier_handler(identifier, symbolTable)
		name = identifier.name.value
		# Variable not declared
		if(symbolTable.lookup(name).nil?) then
			raise SemanticError.new name, "variable not declared"
		# Return variable type
		else
			return symbolTable.lookup(name)
		end
	end

	def logical_bin_expr_handler(instr, symbolTable)
		# Type of left hand expression
		leftType = expr_handler(instr.left, symbolTable)
		# Type of right hand expression
		rightType = expr_handler(instr.right, symbolTable)
				
		# If both sides are boolean then it's well-formed
		if(leftType.eql? "boolean" and rightType.eql? "boolean") then
			return "boolean"
		else
			raise SemanticError.new instr, "logical bin expr operand types are not boolean"
		end
	end

	def logical_un_expr_handler(instr, symbolTable)
		# Type of expression operand
		operandType = expr_handler(instr.operand, symbolTable)

		# If operand type is boolean then it's well-formed
		if(operandType.eql? "boolean") then
			return "boolean"
		else
			raise SemanticError.new instr, "logical un expr operand type is not boolean"
		end
	end

	def arith_bin_expr_handler(instr, symbolTable)
		# Type of left hand expression
		leftType = expr_handler(instr.left, symbolTable)
		# Type of right hand expression
		rightType = expr_handler(instr.right, symbolTable)
				
		# If both sides are number then it's well-formed
		if(leftType.eql? "number" and rightType.eql? "number") then
			return "number"
		else
			raise SemanticError.new instr, "arith bin expr operand types are not number"
		end
	end

	def arith_un_expr_handler(instr, symbolTable)
		# Type of expression operand
		operandType = expr_handler(instr.operand, symbolTable)

		# If operand type is number then it's well-formed
		if(operandType.eql? "number") then
			return "number"
		else
			raise SemanticError.new instr, "arith un expr operand type is not number"
		end
	end

	def comp_expr_handler(instr, symbolTable)
		# Type of left hand expression
		leftType = expr_handler(instr.left, symbolTable)
		# Type of right hand expression
		rightType = expr_handler(instr.right, symbolTable)
		# Operator of expression
		operator = instr.op
		
		# If operator is == or /= then verify equality in operand types
		if (operator.eql? "EQUALITY" or operator.eql? "INEQUALITY") then
			if(leftType.eql? rightType) then
				return "boolean"
			else
				raise SemanticError.new instr, "equality comp expr operand types are not equal"
			end
				
		# If not then verify operand types are number
		else
			if(leftType.eql? "number" and rightType.eql? "number") then
				return "boolean"
			else
				raise SemanticError.new instr, "order comp expr operand types are not numbers"
			end
		end

	end

	def callfunc_handler(instr, symbolTable)
		
		# Get function identifier
		ident = instr.ident.name.value

		# Function is declared
		if (not $funcTable.lookup(ident).nil?) then

			# Parameters/arguments verification
			funcParams = $funcTable.get_funcParams(ident)
			params = Array.new
			# Copy function parameters for argument verifications
			funcParams.each do |param|
				params << param
			end
			arglist_handler(instr.arglist, params, symbolTable)
		
			# Return function return type
			return $funcTable.lookup(ident)

		# Function not declared
		else
			raise SemanticError.new instr, "function not declared"
		end
	end

	def arglist_handler(args, params, symbolTable)
		
		if(args.nil?) then
			
			# Empty argument list and not empty parameter list
			if(params.any?) then
				raise SemanticError.new params, "function call not enough arguments"
			end
		
		else
			
			# Not empty argument list and empty parameter list
			if(not params.any?) then
				raise SemanticError.new params, "function call too many arguments"
			else
				# Check correct argument type in function call
				arg = args.arg
				argType = expr_handler(arg, symbolTable)
				
				param = params.shift
				paramType = param["type"]
				
				if(not argType.eql? paramType) then
					raise SemanticError.new param, "function call argument type mismatch"
				end
				arglist_handler(args.arglist,params,symbolTable)
			end			
		end
	end

	def assignop_handler(instr, symbolTable)

		# Check variable is declared and get its type
		identType = identifier_handler(instr.ident, symbolTable)

		# Check expression is well-formed and get its type
		exprType = expr_handler(instr.expr, symbolTable)

		# Check variable type and expression type are equal
		if(not identType.eql? exprType) then
			raise SemanticError.new instr, "assign op variable and expression types are not equal"
		end
	end

	def withblk_handler(withblk, predSymbolTable)

		# Create new symbol table for with-block scope
		newSymbolTable = createSymbolTable("with-block",predSymbolTable)

		# Store newly declared variables in new symbol table
		declist_handler(withblk.declist, newSymbolTable)

		# Handle instructions inside with-block
		instrlist_handler(withblk.instrlist, newSymbolTable)

		$tableID.pop()
	end

	def declist_handler(declist, symbolTable)

		# Handle current declaration
		decl_handler(declist.nxt_decl, symbolTable) unless declist.nxt_decl.nil?
		
		# handle following declarations
		declist_handler(declist.decl, symbolTable) unless declist.decl.nil?

	end

	def decl_handler(decl, symbolTable)

		# Declaration type
		type = decl.type.type.value

		# List of declarations
		if(decl.assign.nil?) then
			# Handle list of variables to be stored in symbol table
			identlist_handler(decl.identlist,type,symbolTable)

		# Single declaration with assignment
		else

			# Variable identifier
			ident = decl.assign.ident.name.value

			# Variable not declared (good)
			if(not symbolTable.has_key(ident))
				# Insert variable in symbol table
				symbolTable.insert(ident, type)
				# handle assignment to variable
				assignop_handler(decl.assign, symbolTable)
		
			# Variable already declared in scope
			else
				raise SemanticError.new decl, "variable id not unique in scope"
			end
		end
	end

	def identlist_handler(identlist, type, symbolTable)

		# Variable identifier
		ident = identlist.nxt_ident.name.value
		
		# Variable not declared (good)
		if(not symbolTable.has_key(ident))
			# Insert variable in symbol table
			symbolTable.insert(ident, type)
		# Variable already declared in scope
		else
			raise SemanticError.new ident, "variable id not unique in scope"
		end

		# Handle following identifiers
		identlist_handler(identlist.ident, type, symbolTable) unless identlist.ident.nil?

	end

	def read_handler(read, symbolTable)

		# Variable identifier
		ident = read.ident.name.value

		# Variable not declared (bad)
		if(symbolTable.lookup(ident).nil?) then
			raise SemanticError.new read, "variable not declared"
		end

	end

	def write_handler(write, symbolTable)

		# Handle writelist of expressions
		writeList_handler(write.writelist, symbolTable) unless write.writelist.nil?

		# If last item is not a string, then handle the expression
		if !(write.lastitem.instance_of? String_node) then
			expr_handler(write.lastitem, symbolTable)
		end
	end

	def writeList_handler(writelist, symbolTable)

		# Handle writelist of expressions
		writeList_handler(writelist.nxt_write, symbolTable) unless writelist.nxt_write.nil?

		# If last item is not a string, then handle the expression
		if (not writelist.cur_write.nil? and not writelist.cur_write.instance_of? String_node) then
			expr_handler(writelist.cur_write, symbolTable)
		end
	end

	def if_handler(ifblk, symbolTable)

		# Get type of 'if' condition
		condType = expr_handler(ifblk.cond, symbolTable)

		# Condition type must be boolean
		if(not condType.eql? "boolean") then
			raise SemanticError.new ifblk, "if condition type not boolean"
		end

		# Handle instruction block of 'if'
		instrlist_handler(ifblk.instrlist1, symbolTable)
		# Handle instruction block of 'else'
		instrlist_handler(ifblk.instrlist2, symbolTable) unless ifblk.instrlist2.nil?
	end

	def while_loop_handler(whileblk, symbolTable)
		
		# Get type of 'while' condition
		condType = expr_handler(whileblk.expr, symbolTable)

		# Condition type must be boolean
		if(not condType.eql? "boolean") then
			raise SemanticError.new whileblk, "while condition type not boolean"
		end		

		# Handle 'while' instruction block
		instrlist_handler(whileblk.instrlist, symbolTable)
	end

	def for_loop_handler(forblk, predSymbolTable)

		# Create new symbol table for for-block scope
		newSymbolTable = createSymbolTable("for-loop",predSymbolTable)

		# Store for variable in new symbol table
		newSymbolTable.insert(forblk.counter.name.value, "number")	

		# Check lower bound expression type is number
		lowerBoundType = expr_handler(forblk.lower_bound, newSymbolTable)
		if(not lowerBoundType.eql? "number") then
			raise SemanticError.new forblk, "for lower bound type not number"
		end

		# Check upper bound expression type is number
		upperBoundType = expr_handler(forblk.upper_bound, newSymbolTable)
		if(not upperBoundType.eql? "number") then
			raise SemanticError.new forblk, "for upper bound type not number"
		end

		# Check increment expression type is number
		incrementType = expr_handler(forblk.increment, newSymbolTable)
		if(not incrementType.eql? "number") then
			raise SemanticError.new forblk, "for increment type not number"
		end

		# Handle 'for' instruction block
		instrlist_handler(forblk.instrlist, newSymbolTable)
	
		$tableID.pop()
	end

	def for_loop_const_handler(constforblk, predSymbolTable)

		# Create new symbol table for const-for-block scope
		newSymbolTable = createSymbolTable("const-for-loop",predSymbolTable)

		# Store const-for variable in new symbol table
		newSymbolTable.insert(constforblk.counter.name.value, "number")	

		# Check lower bound expression type is number
		lowerBoundType = expr_handler(constforblk.lower_bound, newSymbolTable)
		if(not lowerBoundType.eql? "number") then
			raise SemanticError.new constforblk, "const for lower bound type not number"
		end

		# Check upper bound expression type is number
		upperBoundType = expr_handler(constforblk.upper_bound, newSymbolTable)
		if(not upperBoundType.eql? "number") then
			raise SemanticError.new constforblk, "const for upper bound type not number"
		end

		# Handle 'const-for' instruction block
		instrlist_handler(constforblk.instrlist, newSymbolTable)

		$tableID.pop()
	end

	def repeat_loop_handler(repeat, symbolTable)

		# Check repeat expression type is number
		repeatType = expr_handler(repeat.expr, symbolTable)
		if(not repeatType.eql? "number") then
			raise SemanticError.new repeat, "repeat expr type not number"
		end

		# Handle 'repeat' instruction block
		instrlist_handler(repeat.instrlist, symbolTable)
	end

	# Handle main program block
	def programblk_handler(programblk, symbolTable)
		
		# Create new symbol table for program scope
		newSymbolTable = createSymbolTable("program",symbolTable)

		# Handle block of instructions
		instrlist_handler(programblk.instrlist, newSymbolTable)
	
		$tableID.pop()
	end

	# Store retina pre-defined functions in function symbol table
	def retinaFunc_handler()
		$funcTable.insert("home","void",Array[])
		$funcTable.insert("openeye","void",Array[])
		$funcTable.insert("closeeye","void",Array[])
		$funcTable.insert("forward","void",Array[{"ident"=>"steps", "type"=>"number"}])
		$funcTable.insert("backward","void",Array[{"ident"=>"steps", "type"=>"number"}])
		$funcTable.insert("rotater","void",Array[{"ident"=>"degree", "type"=>"number"}])
		$funcTable.insert("rotatel","void",Array[{"ident"=>"degree", "type"=>"number"}])
		$funcTable.insert("setposition","void",Array[{"ident"=>"x", "type"=>"number"}, {"ident"=>"y", "type"=>"number"}])
		$funcTable.insert("arc","void",Array[{"ident"=>"degree", "type"=>"number"}, {"ident"=>"radius", "type"=>"number"}])
	end

	# Create new symbol table
	def createSymbolTable(name,predecessor)
		
		# Create new table with corresponding ID
		lastID = $tableID.pop
		
		if(predecessor.name.eql? "ROOT TABLE") then
			newSymbolTable = SymbolTable.new lastID.to_s, name
		else
			newSymbolTable = SymbolTable.new predecessor.id + "." + lastID.to_s, name
		end

		$tableID.push(lastID+1)
		$tableID.push(1)

		# Link to predecessor
		newSymbolTable.set_predecessor(predecessor)
		predecessor.add_child(newSymbolTable)
		
		return newSymbolTable
	end

	# Raise semantic error if found
	def on_error(id, token, stack)
    	raise SemanticError::new(token)
	end

end