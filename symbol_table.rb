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

	attr_accessor :id, :name, :children

	def initialize(id = nil, name = nil, predecessor = nil)
		@id = id
		@name = name.upcase
		@table = Hash.new
		@predecessor = predecessor
		@children = Array.new
	end

	def insert(key, value)
		@table.store(key, value)
	end

	def delete(key)
		@table.delete(key)
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

	def update(key, value)
		if !(has_key(key))
			if (@predecessor != nil)
				return father.lookup(key)
			else
				return nil
			end
		else
			return @table[key]
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
		puts "SYMBOL TABLES"
		@children.each do |child|
			puts "\n"
			child.print_table()
		end	
	end

	def print_table(depth = 0)
		
		# Table name
		indent(depth)
		puts "TABLE " + @id.to_s + " " + @name.to_s
		
		# "Variables" title
		indent(depth+1)
		if(@table.empty?)
			puts "VARIABLES: None"
		else
			puts "VARIABLES:"
		end

		# Print table variables
		@table.each do |ident, type|
			indent(depth+2)
			puts ident.to_s + " : " + type.to_s
		end
		
		# "Sub-scopes" title
		indent(depth+1)
		if(@children.empty?)
			puts "SUB-TABLES: None"
		else
			puts "SUB-TABLES:"
		end
		
		# Print child tables
		@children.each do |child|
			child.print_table(depth+2)
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
		super(nil,name)
		@funcParam = Hash.new
	end

	def get_funcParams(func)
		return @funcParam[func]
	end

	def insert(func,type,params)
		super(func,type)
		@funcParam[func] = params		
	end

end