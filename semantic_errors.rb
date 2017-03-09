#   Traductores e Interpretadores CI-3725
#   
#   Proyecto Fase 3 - Semantic Errors
#
#   Autores:
#               - Jose Acevedo      13-10006
#               - Edwar Yepez       12-10855
#

class SemanticError < RuntimeError

    def initialize(tok, errorType)
        @token = tok
        @errorType = errorType
    end

    def to_s
    	puts "SEMANTIC ERROR FOUND:"

    	# Print message according to error type
    	case @errorType
    	when "function id not unique"
    		"epa funcion id ya usada"
    	
    	when "parameter id not unique"
    		"epa parametro id repetido"
    	
    	when "variable not declared"
    		"epa eta variable no ta declarada menolsa"
    	
    	when "return type doesnt match function type"
    		"ese return no coincide con la funcion papa"

		when "empty return instruction in non-void function"
    		"mira esta funcion es number o boolean y me tienes un return sin nada"

    	when "return instruction in void function"
    		"esperate, esa funcion es void y hay un return"
    	
    	when "return instruction not found in non-void function"
    		"mira chico esa funcion non-void no tiene return"
    	
    	when "logical bin expr operand types are not boolean"
    		"te voy a deci una vaina, y te la voy a decir 1 vez, esa expr log bin sus operandos no soon bool"
    	
    	when "logical un expr operand type is not boolean"
    		"mira. le pusiste un not a un numero mamawebo"
    	
    	when "arith bin expr operand types are not number"
    		"verga chamo, no me estes sumando true + true"
    	
    	when "arith un expr operand type is not number"
    		"cuidao.. no me estes haciendo -true"

    	when "equality comp expr operand types are not equal"
    		"chamo se consecuente con los tipos. Kejeso de igualar numbers y booleans"

    	when "order comp expr operand types are not numbers"
    		"la cagaste pues, solo se puede ordenar numbers"
    		
    	when "function not declared"
    		"no seas imbecil, si vas a llamar la funcion, declarala primero"

    	when "function call not enough arguments"
    		"no seas caleta y pasame mas argumentos"

    	when "function call too many arguments"
    		"no me metas mas de la cuenta papa"

    	when "function call argument type mismatch"
    		"chamo el tipo de ese argumento no corresponde con el tipo esperado"

    	when "assign op variable and expression types are not equal"
    		"que broma chico, en esta asignacion los tipos de var y expr no coinciden"

    	when "variable id not unique in scope"
    		"mira chico eto ta trifasico pero me tas declarando la variable dos veces en el mismo alcance"

    	when "if condition type not boolean"
    		"menorsa ese if esta como betoso, no me tas dando una condicion booleana"

    	when "while condition type not boolean"
    		"ete beethoven del while no es boolean"

    	when "for lower bound type not number"
    		"manubrio el lower bound del for no es number"

    	when "for upper bound type not number"
    		"chamita ese upper bound del for no es number"

    	when "for increment type not number"
    		"los reos se soltaron y ese increment del for no es number"
 
    	when "const for lower bound type not number"
    		"te me quedas tranquilo que ese const for lower bound no es number"

    	when "const for upper bound type not number"
    		"tranquilo que ese const fot upper bound no es number"

    	when "repeat expr type not number"
    		"rapidito que melanie me ta apurando: ese expr de repeat no es number"

    	end
    end
end