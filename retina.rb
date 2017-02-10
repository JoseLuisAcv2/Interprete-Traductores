#!/usr/bin/ruby
#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 1 - Interpreter main file
#
# 	Autores:
# 				- Jose Acevedo		13-10006
# 				- Edwar Yepez		12-10855
#

require_relative 'retina_lexer'
require_relative 'retina_parser'

def main

	#Check file was given
	if ARGV[0].nil? then
		puts "Enter Retina file.";
		return;
	end;

	# Check file exists
	if not File.file?(ARGV[0]) then
		puts "File does not exist.";
		return;
	end;

	# Check '.rtn' file extension
	ARGV[0] =~ /\w+\.rtn/;
	if $&.nil? then
		puts "Invalid file extension.";
		return;
	end;

	# Create lexer
	lexer = Lexer.new ARGV[0];
	lexer.get_tokens;

	if lexer.has_lexicographic_errors then
		lexer.print_lexicographic_errors;
		return;
	end;

	parser = Parser.new;
	ast = parser.parse lexer;
	#ast.print_ast;

end;

main