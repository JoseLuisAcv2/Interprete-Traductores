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

$rootTable = SymbolTable.new
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
		newSymbolTable = SymbolTable.new "Table " + ident
		newSymbolTable.set_predecessor(symbolTable)
		symbolTable.add_child(newSymbolTable)
		### FALTA RELLENAR TABLA rellenar()


		# Almacenar funcion en tabla de funciones
		# Chequear unicidad de identificador de funcion
		if($funcTable.lookup(ident).nil?) then
			$funcTable.insert(ident,type)
			# Almacenar apuntador a tabla de simbolos de la funcion para hacer chequeos de parametros
			$funcTable.attach(ident,newSymbolTable)

		# Identificador para funcion ya utilizado
		else
			puts "repetido"    # ALMACENAR ERROR
		end

	end























	# Handle main program block
	def programblk_handler(programblk, symbolTable)
		puts "program blk coming soon..."
	end









	# Raise semantic error if found
	def on_error(id, token, stack)
    	raise SemanticError::new(token)
	end

end

class SemanticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        if @token.eql? "$" then
            "Unexpected EOF"
        else
            "Line #{@token.line}, column #{@token.column}: unexpected token #{@token.symbol}: #{@token.value}"   
        end
    end
end