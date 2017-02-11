#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 1 - Lexer
#
# 	Autores:
# 				- Jose Acevedo		13-10006
# 				- Edwar Yepez		12-10855
#

class Token
	attr_reader :symbol
	attr_reader :value
	attr_reader :line
	attr_reader :column
  
	def initialize symbol, value, line, column
		@symbol = symbol
		@value = value
		@line = line
		@column = column
	end

	def to_s
  		"Tk#{self.class}"
	end
end

class LexicographicError < RuntimeError
	def initialize t
		@t = t
	end

	def to_s
		"Unknown lexeme \'#{@t}\'"
	end
end

class Lexer
	attr_reader :tokens;

	def initialize input_file
		@cur_token = 0;
		@input_file	= input_file;
		@tokens = Array.new;
		@lexicographic_errors = Array.new;
	end;

	def get_tokens
		lineIndex = 0

		File.open(@input_file) do |file|
			file.each_line do |line|
				lineIndex += 1
				colIndex = 1

				while line != ""
				
					case line
	
					when /^\t+/
						word = line[/^\t+/]
						line = line.partition(word).last
						colIndex += 4
					when /^\s+/
						word = line[/^\s+/]
						line = line.partition(word).last
						colIndex += word.size
					when /^#/
						word = line[/^#/]
						line = ""
					when /^program/
						word = line[/^program/]
						line = line.partition(word).last
						@tokens << Token.new(:PROGRAM, word, lineIndex, colIndex)
						colIndex += word.size
					when /^begin/
						word = line[/^begin/]
						line = line.partition(word).last
						@tokens << Token.new(:BEGINBLK, word, lineIndex, colIndex)
						colIndex += word.size
					when /^end/
						word = line[/^end/]
						line = line.partition(word).last
						@tokens << Token.new(:ENDBLK, word, lineIndex, colIndex)
						colIndex += word.size
					when /^with/
						word = line[/^with/]
						line = line.partition(word).last
						@tokens << Token.new(:WITH, word, lineIndex, colIndex)
						colIndex += word.size
					when /^do/
						word = line[/^do/]
						line = line.partition(word).last
						@tokens << Token.new(:DO, word, lineIndex, colIndex)
						colIndex += word.size
					when /^repeat/
						word = line[/^repeat/]
						line = line.partition(word).last
						@tokens << Token.new(:REPEAT, word, lineIndex, colIndex)
						colIndex += word.size	
					when /^times/
						word = line[/^times/]
						line = line.partition(word).last
						@tokens << Token.new(:TIMES, word, lineIndex, colIndex)
						colIndex += word.size
					when /^read/
						word = line[/^read/]
						line = line.partition(word).last
						@tokens << Token.new(:READ, word, lineIndex, colIndex)
						colIndex += word.size
					when /^write/
						word = line[/^write/]
						line = line.partition(word).last
						@tokens << Token.new(:WRITE, word, lineIndex, colIndex)
						colIndex += word.size
					when /^writeln/
						word = line[/^writeln/]
						line = line.partition(word).last
						@tokens << Token.new(:WRITELN, word, lineIndex, colIndex)
						colIndex += word.size
					when /^if/
						word = line[/^if/]
						line = line.partition(word).last
						@tokens << Token.new(:IF, word, lineIndex, colIndex)
						colIndex += word.size
					when /^then/
						word = line[/^then/]
						line = line.partition(word).last
						@tokens << Token.new(:THEN, word, lineIndex, colIndex)
						colIndex += word.size
					when /^else/
						word = line[/^else/]
						line = line.partition(word).last
						@tokens << Token.new(:ELSE, word, lineIndex, colIndex)
						colIndex += word.size
					when /^while/
						word = line[/^while/]
						line = line.partition(word).last
						@tokens << Token.new(:WHILE, word, lineIndex, colIndex)
						colIndex += word.size
					when /^for/
						word = line[/^for/]
						line = line.partition(word).last
						@tokens << Token.new(:FOR, word, lineIndex, colIndex)
						colIndex += word.size
					when /^from/
						word = line[/^from/]
						line = line.partition(word).last
						@tokens << Token.new(:FROM, word, lineIndex, colIndex)
						colIndex += word.size
					when /^to/
						word = line[/^to/]
						line = line.partition(word).last
						@tokens << Token.new(:TO, word, lineIndex, colIndex)
						colIndex += word.size
					when /^by/
						word = line[/^by/]
						line = line.partition(word).last
						@tokens << Token.new(:BY, word, lineIndex, colIndex)
						colIndex += word.size
					when /^func/
						word = line[/^func/]
						line = line.partition(word).last
						@tokens << Token.new(:FUNC, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^return/
						word = line[/^return/]
						line = line.partition(word).last
						@tokens << Token.new(:RETURN, word, lineIndex, colIndex)
						colIndex += word.size

					when /^->/
						word = line[/^->/]
						line = line.partition(word).last
						@tokens << Token.new(:RETURNOP, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^(boolean|number)/
						word = line[/^(boolean|number)/]
						line = line.partition(word).last
						@tokens << Token.new(:TYPE, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^(true|false)/
						word = line[/^(true|false)/]
						line = line.partition(word).last
						@tokens << Token.new(:BOOLEAN, word, lineIndex, colIndex)
						colIndex += word.size

					when /^not/
						word = line[/^not/]
						line = line.partition(word).last
						@tokens << Token.new(:NOT, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^(and|or)/
						word = line[/^(and|or)/]
						line = line.partition(word).last
						@tokens << Token.new(:BOP, word, lineIndex, colIndex)
						colIndex += word.size

					when /^(==|\/=)/
						word = line[/^(==|\/=)/]
						line = line.partition(word).last
						@tokens << Token.new(:EQUALITYOP, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^(>=?|<=?)/
						word = line[/^(>=?|<=?)/]
						line = line.partition(word).last
						@tokens << Token.new(:ORDEROP, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^\(/
						word = line[/^\(/]
						line = line.partition(word).last
						@tokens << Token.new(:LPARENTH, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^\)/
						word = line[/^\)/]
						line = line.partition(word).last
						@tokens << Token.new(:RPARENTH, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^=/
						word = line[/^=/]
						line = line.partition(word).last
						@tokens << Token.new(:ASSIGNOP, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^;/
						word = line[/^;/]
						line = line.partition(word).last
						@tokens << Token.new(:SEP, word, lineIndex, colIndex)
						colIndex += word.size

					when /^,/
						word = line[/^,/]
						line = line.partition(word).last
						@tokens << Token.new(:COLON, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^(\+|-|\*|\/|%|div|mod)/
						word = line[/^(\+|-|\*|\/|%|div|mod)/]
						line = line.partition(word).last
						@tokens << Token.new(:ARITHMETICOP, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^([1-9][0-9]*|0)(\.[0-9]+)?/
						word = line[/^([1-9][0-9]*|0)(\.[0-9]+)?/]
						line = line.partition(word).last
						@tokens << Token.new(:NUMBER, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^"([^\\n\"\\]|\\\\|\\\\n|\\\")*"/
						word = line[/^"([^\\n\"\\]|\\\\|\\\\n|\\\")*"/]
						line = line.partition(word).last
						@tokens << Token.new(:STRING, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^[a-z][a-zA-Z0-9_]*/
						word = line[/^[a-z][a-zA-Z0-9_]*/]
						line = line.partition(word).last
						@tokens << Token.new(:IDENTIFIER, word, lineIndex, colIndex)
						colIndex += word.size
	
					else
						word = line[/^./]
						line = line.partition(word).last
						@lexicographic_errors << Token.new("", word, lineIndex, colIndex)
						colIndex += word.size
					end
				end
			end
		end
	end


	# Checks whether there are any tokens left
	def has_next_token
		return @cur_token < @tokens.length;
	end;


	# Returns next token
	def next_token
		token = @tokens[@cur_token];
		@cur_token = @cur_token + 1;
		return token;
	end;


	# Checks whether input file has any lexicographic errors
	def has_lexicographic_errors
		return @lexicographic_errors.any?;
	end;


	# Prints all lexicographic erros found in the input file
	def print_lexicographic_errors
		@lexicographic_errors.each do |token|
			puts "Line #{token.line}, column #{token.column}: unexpected character '#{token.value}'";
		end;
	end;


	# Prints all tokens found in the input file
	def print_tokens
		@tokens.each do |token|
			puts "Line #{token.line}, column #{token.column}: #{token.symbol} '#{token.value}'";
		end;		
	end;

end;