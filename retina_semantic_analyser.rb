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

$rootTable = SymbolTable.new "Root Table"
$funcTable = FuncSymbolTable.new

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

		# Identificador de funcion
		ident = funcdef.ident.name.value

		# Tipo de retorno
		if(funcdef.type.type.nil?) then
			type = "Void"
		else
			type = funcdef.type.type.value
		end

		# Crear nueva tabla de simbolos para alcance de funcion
		newSymbolTable = createSymbolTable(ident,symbolTable)
		### FALTA RELLENAR TABLA rellenar()


		# Almacenar funcion en tabla de funciones
		# Chequear unicidad de identificador de funcion
		if($funcTable.lookup(ident).nil?) then
			$funcTable.insert(ident,type)
			# Almacenar apuntador a tabla de simbolos de la funcion para hacer chequeos de parametros
			$funcTable.attach(ident,newSymbolTable)

		# Identificador para funcion ya utilizado
		else
			raise SemanticError.new funcdef, "function id not unique"
		end

	end























	# Handle main program block
	def programblk_handler(programblk, symbolTable)
		puts "program blk coming soon..."
	end

	# Create new symbol table
	def createSymbolTable(name,predecessor)
		newSymbolTable = SymbolTable.new "Table " + name
		newSymbolTable.set_predecessor(predecessor)
		predecessor.add_child(newSymbolTable)
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
    		"epa funcion ya definida"
    	end
    end
end