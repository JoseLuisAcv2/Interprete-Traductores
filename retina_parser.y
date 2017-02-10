class Parser

	token Reserved;

start Retina

rule

	Retina: Expression {puts val[0] }

    Expression: Reserved;
end

---- header

require_relative "retina_lexer"
require_relative "retina_ast"

class SyntacticError < RuntimeError

    def initialize(tok)
        @token = tok
    end

    def to_s
        "Syntactic error on line #{@token.line}, column #{@token.column}: #{@token.t}"   
    end
end

---- inner

def on_error(id, token, stack)
    raise SyntacticError::new(token)
end

def next_token
	if @lexer.has_next_token then
		token = @lexer.next_token;
        case token.class.to_s
        when "Reserved"
            return [:Reserved,token.t]

        end
    else
        return [false,false];
	end
end

def parse(lexer)
    @yydebug = true
    @lexer = lexer
    @tokens = []
    ast = do_parse
    return ast
end