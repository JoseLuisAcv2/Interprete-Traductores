#
# 	Traductores e Interpretadores CI-3725
# 	
# 	Proyecto Fase 4 - Interpreter
#
#  	Retina Drawing Library
#
# 	Autores:
# 				- Jose Acevedo		13-10006
#               - Edwar Yepez       12-10855
#

# Compare to retina predefined functions
def retina_function(funcCall)

	# Function identifier
	funcIdent = funcCall.ident.name.value

	# If match found then call function
	case funcIdent
	when "home"
		home()
		return true
	
	when "openeye"
		openeye()
		return true
	
	when "closeeye"
		closeeye()
		return true
	
	when "forward"
		steps = funcCall.arglist.arg.value.value
		forward(steps)
		return true
	
	when "backward"
		steps = funcCall.arglist.arg.value.value
		backward(steps)
		return true
	
	when "rotater"
		degree = funcCall.arglist.arg.value.value
		rotater(degree)
		return true
	
	when "rotatel"
		degree = funcCall.arglist.arg.value.value
		rotatel(degree)
		return true
	
	when "setposition"
		x = funcCall.arglist.arg.value.value
		y = funcCall.arglist.arglist.arg.value.value
		setposition(x,y)
		return true
	
	when "arc"
		degree = funcCall.arglist.arg.value.value
		radius = funcCall.arglist.arglist.arg.value.value
		arc(degree,radius)
		return true
	
	end
end

def home()
end

def openeye()
end

def closeeye()
end

def forward(steps)
end

def backward(steps)
end

def rotater(degree)
end

def rotatel(degree)
end

def setposition(x,y)
end

def arc(degree,radius)
end