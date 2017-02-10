class Parser

	token 'program'

	prechigh
		nonassoc 'program'
	preclow

start Retina

rule

	Retina: 'program';


---- header

require_relative "retina_lexer"

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        "Syntactic error on: #{@token}"   
    end
end


---- inner

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end


def next_token
	#if @lexer.has_next_token then
	#	return @lexer.next_token;
	#else
		return [false,false];
	#end
end

def parse(lexer)
    @yydebug = true
    @lexer = lexer
    @tokens = []
    ast = do_parse
    return ast
end