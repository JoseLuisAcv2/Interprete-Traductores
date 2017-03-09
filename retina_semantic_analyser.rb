# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 3 - Semantic Analyser
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#               - Edwar Yepez       12-10855
#

require_relative 'symbol_table'

$rootTable = SymbolTable.new "Root Table"
$funcTable = FuncSymbolTable.new
$returnFound
$curFunction

# Semantic analyser for abstract syntax tree
class SemanticAnalyser

	def initialize(ast)
		@ast = ast
	end

	# Analyze AST
	def analyze()
		scope_handler(@ast)
		return $rootTable
	end

	# Handle entry point to AST
	def scope_handler(scope)

		# Fuction definition block
		if not scope.defblk.nil? then
			defblk_handler(scope.defblk, $rootTable)
		end
		# Main program block
		programblk_handler(scope.programblk, $rootTable)
		
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
		#when While_loop_node
		#when For_loop_node
		#when For_loop_const_node
		#when Repeat_loop_node
		#when If_node
		#when Read_node
		#when Write_node
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
	
			exprType = expr_handler(instr.expr, symbolTable)
			exprType = "number" # POR AHORAAAAAAAAAAAAAAAAAAA
	
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
		if(not symbolTable.lookup(name)) then
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
		if ($funcTable.has_key(ident)) then

			# Parameters/arguments verification
			params = $funcTable.get_funcParams(ident)
			arglist_handler(instr.arglist, params, symbolTable)
		
			# Return function return type
			return $funcTable.has_key(ident)

		# Function not declared
		else
			SemanticError.new instr, "function not declared"
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
		newSymbolTable = createSymbolTable("withblk",predSymbolTable)

		# Store newly declared variables in new symbol table
		declist_handler(withblk.declist, newSymbolTable)

		# Handle instructions inside with-block
		instrlist_handler(withblk.instrlist, newSymbolTable)

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
			if(symbolTable.lookup(ident).nil?)
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
		if(symbolTable.lookup(ident).nil?)
			# Insert variable in symbol table
			symbolTable.insert(ident, type)
		# Variable already declared in scope
		else
			raise SemanticError.new ident, "variable id not unique in scope"
		end

		# Handle following identifiers
		identlist_handler(identlist.ident, type, symbolTable) unless identlist.ident.nil?

	end












	# Handle main program block
	def programblk_handler(programblk, symbolTable)
		#puts "program blk coming soon..."
	end

	# Create new symbol table
	def createSymbolTable(name,predecessor)
		newSymbolTable = SymbolTable.new "Scope " + name
		newSymbolTable.set_predecessor(predecessor)
		predecessor.add_child(newSymbolTable)
		return newSymbolTable
	end

	# Raise semantic error if found
	def on_error(id, token, stack)
    	raise SemanticError::new(token)
	end

end

class SemanticError < RuntimeError

    def initialize(tok, errorType)
        @token = tok
        @errorType = errorType
    end

    def to_s
    	# Print message according to error type
    	case @errorType
    	when "function id not unique"
    		"epa funcion id ya usada"
    	
    	when "parameter id not unique"
    		"epa parametro id repetido"
    	
    	when "variable not declared"
    		"epa eta variable no ta declarada"
    	
    	when "return type doesnt match function type"
    		"ese return no coincide con la funcion papa"

		when "empty return instruction in non-void function"
    		"mira esta funcion es number o boolean y me tienes un return sin nada"

    	when "return instruction in void function"
    		"esperate, esa funcion es void y hay un return"
    	
    	when "return instruction not found in non-void function"
    		"mira chico esa funcion non-void no tiene return"
    	
    	when "logical bin expr operand types are not boolean"
    		"te voy a deci una vaina, y te la voy a decir 1 vez, esa expr log bin sus operandos no soon bool"
    	
    	when "logical un expr operand type is not boolean"
    		"mira. le pusiste un not a un numero mamawebo"
    	
    	when "arith bin expr operand types are not number"
    		"verga chamo, no me estes sumando true + true"
    	
    	when "arith un expr operand type is not number"
    		"cuidao.. no me estes haciendo -true"

    	when "equality comp expr operand types are not equal"
    		"chamo se consecuente con los tipos. Kejeso de igualar numbers y booleans"

    	when "order comp expr operand types are not numbers"
    		"la cagaste pues, solo se puede ordenar numbers"
    		
    	when "function not declared"
    		"no seas imbecil, si vas a llamar la funcion, declarala primero"

    	when "function call not enough arguments"
    		"no seas caleta y pasame mas argumentos"

    	when "function call too many arguments"
    		"no me metas mas de la cuenta papa"

    	when "function call argument type mismatch"
    		"chamo el tipo de ese argumento no corresponde con el tipo esperado"

    	when "assign op variable and expression types are not equal"
    		"que broma chico, en esta asignacion los tipos de var y expr no coinciden"

    	when "variable id not unique in scope"
    		"mira chico eto ta trifasico pero me tas declarando la variable dos veces en el mismo alcance"

    	end
    end
end