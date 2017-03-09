#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 1 - Lexer
#
# 	Autores:
# 				- Jose Acevedo		13-10006
# 				- Edwar Yepez 		12-10855
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
					
					when /^program[^a-zA-Z0-9_]/
						word = line[/^program/]
						line = line.partition(word).last
						@tokens << Token.new(:PROGRAM, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^begin[^a-zA-Z0-9_]/
						word = line[/^begin/]
						line = line.partition(word).last
						@tokens << Token.new(:BEGINBLK, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^end[^a-zA-Z0-9_]/
						word = line[/^end/]
						line = line.partition(word).last
						@tokens << Token.new(:ENDBLK, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^with[^a-zA-Z0-9_]/
						word = line[/^with/]
						line = line.partition(word).last
						@tokens << Token.new(:WITH, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^do[^a-zA-Z0-9_]/
						word = line[/^do/]
						line = line.partition(word).last
						@tokens << Token.new(:DO, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^repeat[^a-zA-Z0-9_]/
						word = line[/^repeat/]
						line = line.partition(word).last
						@tokens << Token.new(:REPEAT, word, lineIndex, colIndex)
						colIndex += word.size	
					
					when /^times[^a-zA-Z0-9_]/
						word = line[/^times/]
						line = line.partition(word).last
						@tokens << Token.new(:TIMES, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^read[^a-zA-Z0-9_]/
						word = line[/^read/]
						line = line.partition(word).last
						@tokens << Token.new(:READ, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^write[^a-zA-Z0-9_]/
						word = line[/^write/]
						line = line.partition(word).last
						@tokens << Token.new(:WRITE, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^writeln[^a-zA-Z0-9_]/
						word = line[/^writeln/]
						line = line.partition(word).last
						@tokens << Token.new(:WRITELN, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^if[^a-zA-Z0-9_]/
						word = line[/^if/]
						line = line.partition(word).last
						@tokens << Token.new(:IF, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^then[^a-zA-Z0-9_]/
						word = line[/^then/]
						line = line.partition(word).last
						@tokens << Token.new(:THEN, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^else[^a-zA-Z0-9_]/
						word = line[/^else/]
						line = line.partition(word).last
						@tokens << Token.new(:ELSE, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^while[^a-zA-Z0-9_]/
						word = line[/^while/]
						line = line.partition(word).last
						@tokens << Token.new(:WHILE, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^for[^a-zA-Z0-9_]/
						word = line[/^for/]
						line = line.partition(word).last
						@tokens << Token.new(:FOR, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^from[^a-zA-Z0-9_]/
						word = line[/^from/]
						line = line.partition(word).last
						@tokens << Token.new(:FROM, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^to[^a-zA-Z0-9_]/
						word = line[/^to/]
						line = line.partition(word).last
						@tokens << Token.new(:TO, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^by[^a-zA-Z0-9_]/
						word = line[/^by/]
						line = line.partition(word).last
						@tokens << Token.new(:BY, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^func[^a-zA-Z0-9_]/
						word = line[/^func/]
						line = line.partition(word).last
						@tokens << Token.new(:FUNC, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^return[^a-zA-Z0-9_]/
						word = line[/^return/]
						line = line.partition(word).last
						@tokens << Token.new(:RETURN, word, lineIndex, colIndex)
						colIndex += word.size

					when /^->/
						word = line[/^->/]
						line = line.partition(word).last
						@tokens << Token.new(:RETURNTYPE, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^(boolean|number)[^a-zA-Z0-9_]/
						word = line[/^(boolean|number)/]
						line = line.partition(word).last
						@tokens << Token.new(:TYPE, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^(true|false)[^a-zA-Z0-9_]/
						word = line[/^(true|false)/]
						line = line.partition(word).last
						@tokens << Token.new(:BOOLEAN, word, lineIndex, colIndex)
						colIndex += word.size

					when /^not[^a-zA-Z0-9_]/
						word = line[/^not/]
						line = line.partition(word).last
						@tokens << Token.new(:NOT, word, lineIndex, colIndex)
						colIndex += word.size

					when /^and[^a-zA-Z0-9_]/
						word = line[/^(and)/]
						line = line.partition(word).last
						@tokens << Token.new(:AND, word, lineIndex, colIndex)
						colIndex += word.size

					when /^or[^a-zA-Z0-9_]/
						word = line[/^or/]
						line = line.partition(word).last
						@tokens << Token.new(:OR, word, lineIndex, colIndex)
						colIndex += word.size

					when /^==/
						word = line[/^==/]
						line = line.partition(word).last
						@tokens << Token.new(:EQOP, word, lineIndex, colIndex)
						colIndex += word.size

					when /^\/=/
						word = line[/^\/=/]
						line = line.partition(word).last
						@tokens << Token.new(:INEQOP, word, lineIndex, colIndex)
						colIndex += word.size
					
					when /^>=/
						word = line[/^>=/]
						line = line.partition(word).last
						@tokens << Token.new(:GEOP, word, lineIndex, colIndex)
						colIndex += word.size

					when /^>/
						word = line[/^>/]
						line = line.partition(word).last
						@tokens << Token.new(:GTOP, word, lineIndex, colIndex)
						colIndex += word.size

					when /^<=/
						word = line[/^<=/]
						line = line.partition(word).last
						@tokens << Token.new(:LEOP, word, lineIndex, colIndex)
						colIndex += word.size						

					when /^</
						word = line[/^</]
						line = line.partition(word).last
						@tokens << Token.new(:LTOP, word, lineIndex, colIndex)
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
					
					when /^\-/
						word = line[/^\-/]
						line = line.partition(word).last
						@tokens << Token.new(:MINUS, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^\+/
						word = line[/^\+/]
						line = line.partition(word).last
						@tokens << Token.new(:PLUS, word, lineIndex, colIndex)
						colIndex += word.size

					when /^(\*)/
						word = line[/^(\*)/]
						line = line.partition(word).last
						@tokens << Token.new(:MULT, word, lineIndex, colIndex)
						colIndex += word.size

					when /^\//
						word = line[/^\//]
						line = line.partition(word).last
						@tokens << Token.new(:DIV, word, lineIndex, colIndex)
						colIndex += word.size

					when /^div[^a-zA-Z0-9_]/
						word = line[/^div/]
						line = line.partition(word).last
						@tokens << Token.new(:INTDIV, word, lineIndex, colIndex)
						colIndex += word.size

					when /^%/
						word = line[/^%/]
						line = line.partition(word).last
						@tokens << Token.new(:MOD, word, lineIndex, colIndex)
						colIndex += word.size

					when /^mod[^a-zA-Z0-9_]/
						word = line[/^mod/]
						line = line.partition(word).last
						@tokens << Token.new(:INTMOD, word, lineIndex, colIndex)
						colIndex += word.size

					when /^([1-9][0-9]*|0)(\.[0-9]+)?/
						word = line[/^([1-9][0-9]*|0)(\.[0-9]+)?/]
						line = line.partition(word).last
						@tokens << Token.new(:NUMBER, word, lineIndex, colIndex)
						colIndex += word.size
	
					when /^"([^\n\"\\]|\\\\|\\\\n|\\")*"/
						word = line[/^"([^\n\"\\]|\\\\|\\\\n|\\\")*"/]
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
		puts "LEXICOGRAPHIC ERRORS FOUND:"
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