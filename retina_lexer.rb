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
	attr_reader :t
	attr_reader :line
	attr_reader :column
  
	def initialize text, line, column
		@t = text
		@line = line
		@column = column
	end

	def to_s
  		"Tk#{self.class}"
	end
end

# Regular expression list that accepts Retina tokens
$tokens = {
	Reserved:  		           				/\A(program|with|do|begin|end|repeat|times|read|write|writeln|if|then|else|while|for|from|to|by|func|return|->)/,
	Type:  					  				/\A(number|boolean)/,
	LogicalOP: 		     	  				/\A(not|and|or)/,
	ComparisonOP: 							/\A(==|!=|>=|>|<=|<)/,
	ArithmeticOP:							/\A(\+|-|\*|\/|%|div|mod)/,
	Sign: 									/\A(\(|\)|=|;|,)/,
	Booleanliteral: 						/\A(true|false)/,
	Numericalliteral: 						/\A([1-9][0-9]*|0)(\.[0-9]+)?/,
	Stringliteral: 							/\A"([^\\n\"\\]|\\\\|\\\\n|\\\")*"/,
	Id: 									/\A[a-z][a-zA-Z0-9_]*/,

}

class LexicographicError < RuntimeError
	def initialize t
		@t = t
	end

	def to_s
		"Unknown lexeme \'#{@t}\'"
	end
end

class Reserved < Token; end
class Sign < Token; end
class Type < Token; end
class LogicalOP < Token; end
class ComparisonOP < Token; end
class ArithmeticOP < Token; end
class Booleanliteral < Token; end
class Numericalliteral < Token; end
class Stringliteral < Token; end
class Id < Token; end

class Lexer
	attr_reader :tokens;

	def initialize input_file
		@cur_token = 0;
		@input_file	= input_file;
		@tokens = Array.new;
		@lexicographic_errors = Array.new;
		@lexicographic_errors_location = Array.new;
	end;


	# Matches word with Retina token
	def get_single_token(word, line, column)
		
		if word.empty? then return end;
	
		$tokens.each do |result, expression|
			if word =~ expression then
				token_class = Object::const_get(result)
				@tokens << token_class.new(word,line,column)
				return;
			end;
		end;
		@lexicographic_errors << (["",word]);
		@lexicographic_errors_location << ([line,column]);
	end;


	# Get tokens from Retina input file
	def get_tokens

		# Read each line of the input Retina file
		is_string = false;
		count = 0;
			
		File.open(@input_file) do |file|
			file.each_line do |line|
				line << ' ';
				word  = "";
				column = 1;
				cur = '';
				line.split("").each_with_index do |nxt, cur_column|				
					if is_string then
						if cur == "\"" then
							if count == 0 then
								is_string = false;
								word << cur;
								get_single_token(word,$.,column);
								word = "";
							 	column = cur_column+1;
							else
								count = 0;
								word << cur;
							end;
						else
							count = cur == "\\"? 1-count : 0;
							word << cur;
						end;
					
					else
						case cur
						when "#"
							get_single_token(word,$.,column);
							break;
						
						when " ","\t","\n"
							get_single_token(word,$.,column);
							word = "";
						 	column = cur_column+1;
						
						when ";","(",")",","
							get_single_token(word,$.,column);
							get_single_token(cur,$.,cur_column);		
							word = "";
						 	column = cur_column+1;					
						
						when "\""
							is_string = true;
							word << cur;
						
						else
							word << cur;
						end;
					end;
					cur = nxt;
				end;
				get_single_token(word,$.,column);
			end;
		end;

		return tokens;
	end;


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
		@lexicographic_errors.zip(@lexicographic_errors_location).each do |result, location|
			puts "Line #{location[0]}, column #{location[1]}: unexpected character '#{result[1]}'";
		end;	
	end;


	# Prints all tokens found in the input file
	def print_tokens
		@tokens.each do |token|
			puts "Line #{token.line}, column #{token.column}: #{token.class} '#{token.t}'";
		end;		
	end;

end;