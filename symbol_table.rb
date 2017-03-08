#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 3 - Symbol Table
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#               - Edwar Yepez       12-10855
#

class SymbolTable

	def initialize(name = nil, predecessor = nil)
		@name = name
		@table = Hash.new
		@predecessor = predecessor
		@children = Array.new
	end

	def insert(key, value)
		@table.store(key, value)
	end

	def lookup(key)
		if(has_key(key))
			return @table[key]
		elsif(@predecessor != nil)
			return @predecessor.lookup(key)
		else
			return nil
		end
	end

	def has_key(key)
		return @table.has_key?(key)
	end

	def table()
		return @table
	end

	def set_predecessor(predecessor)
		@predecessor = predecessor
	end

	def add_child(child_table)
		@children << child_table
	end

	def print_tables()
		@children.each do |child|
			child.print_table()
		end	
	end

	def print_table(depth = 0)
		indent(depth)
		puts @name
		# Print child tables
		@children.each do |child|
			child.print_table(depth+1)
		end	
	end

	# Indent output
	def indent(ind)
        for i in 1..ind
            print "\t"
        end
    end

end

class FuncSymbolTable < SymbolTable

	def initialize(name = nil)
		super(name)
		@funcTable = Hash.new
	end

	def get_funcTable(func)
		return @funcTable[func]
	end

	def attach(func,func_table)
		@funcTable.store(func,func_table)
	end

end