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
		@value = Hash.new
	end

	def insert(key, value)
		@table.store(key, value)
		# Default value
		if value.eql? "void" then
			@value.store(key,nil)
		elsif value.eql? "number" then
			@value.store(key,0)
		elsif value.eql? "boolean" then
			@value.store(key,false)
		end
	end

	def delete(key)
		@table.delete(key)
		@value.delete(key)
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

	def get_value(key)
		if(has_key(key))
			return @value[key]
		else
			return @predecessor.get_value(key)
		end
	end

	def set_value(key, value)
		if(has_key(key))
			@value[key] = value
		else
			@predecessor.set_value(key, value)
		end
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
		@funcDefNode = Hash.new
	end

	def get_funcParams(func)
		return @funcParam[func]
	end

	def get_funcDef(func)
		return @funcDefNode[func]
	end

	def insert(func,type,params,funcDef=nil)
		super(func,type)
		@funcParam[func] = params
		@funcDefNode[func] = funcDef
	end

end