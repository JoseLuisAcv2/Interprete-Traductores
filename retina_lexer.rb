#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 1 - Lexer
#
# 	Autores:
# 				- Jose Acevedo		13-10006
# 				- Edwar Yepez		12-10855
#

# Regular expression list that accepts Retina tokens
$regex = {
	/^program$/								=>		"palabra reservada",
	/^begin$/								=>		"palabra reservada",
	/^end$/									=>		"palabra reservada",
	/^with$/								=>		"palabra reservada",
	/^do$/									=>		"palabra reservada",
	/^repeat$/								=>		"palabra reservada",
	/^times$/								=>		"palabra reservada",
	/^read$/								=>		"palabra reservada",
	/^write$/								=>		"palabra reservada",
	/^writeln$/								=>		"palabra reservada",
	/^if$/									=>		"palabra reservada",
	/^then$/								=>		"palabra reservada",
	/^else$/								=>		"palabra reservada",
	/^while$/								=>		"palabra reservada",
	/^for$/									=>		"palabra reservada",
	/^from$/								=>		"palabra reservada",
	/^to$/									=>		"palabra reservada",
	/^by$/									=>		"palabra reservada",
	/^func$/								=>		"palabra reservada",
	/^return$/								=>		"palabra reservada",
	/^->$/									=>		"palabra reservada",
	/^number$/								=>		"tipo de dato",
	/^boolean$/								=>		"tipo de dato",
	/^true$/								=>		"literal booleano",
	/^false$/								=>		"literal booleano",
	/^and$/									=>		"operador lógico",
	/^or$/									=>		"operador lógico",
	/^not$/									=>		"operador lógico",
	/^==$/									=>		"operador de comparación",
	/^\/=$/									=>		"operador de comparación",
	/^>=$/									=>		"operador de comparación",
	/^<=$/									=>		"operador de comparación",
	/^>$/									=>		"operador de comparación",
	/^<$/									=>		"operador de comparación",
	/^\($/									=>		"signo",
	/^\)$/									=>		"signo",
	/^=$/									=>		"signo",
	/^;$/									=>		"signo",
	/^\+$/									=>		"operador aritmético",
	/^-$/									=>		"operador aritmético",
	/^\*$/									=>		"operador aritmético",
	/^\/$/									=>		"operador aritmético",	
	/^%$/									=>		"operador aritmético",
	/^div$/									=>		"operador aritmético",
	/^mod$/									=>		"operador aritmético",
	/^([1-9][0-9]*|0)(\.[0-9]+)?$/			=>		"literal numérico",
	/^"([^\\n\"\\]|\\\\|\\\\n|\\\")*"$/		=>		"literal de string",
	/^[a-z][a-zA-Z0-9_]*$/					=>		"identificador",
};

class Lexer
	attr_reader :tokens;

	def initialize input_file
		@cur_token=0;
		@input_file	= input_file;
		@tokens = Array.new;
		@tokens_location = Array.new;
		@lexicographic_errors = Array.new;
		@lexicographic_errors_location = Array.new;
	end;


	# Matches word with Retina token
	def get_single_token(word, line, column)
		
		if word.empty? then return end;
	
		$regex.each do |expression, result|
			if word =~ expression then
				@tokens.push([result,word]);
				@tokens_location.push([line,column]);
				return;
			end;
		end;
		@lexicographic_errors.push(["",word]);
		@lexicographic_errors_location.push([line,column]);
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
						
						when " ","\t","\n",","
							get_single_token(word,$.,column);
							word = "";
						 	column = cur_column+1;
						
						when ";","(",")"
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
		@tokens.zip(@tokens_location).each do |result, location|
			puts "Line #{location[0]}, column #{location[1]}: #{result[0]} '#{result[1]}'";
		end;		
	end;

end;