extends Control

## Text Input ##


## Game state control ##
# a dev switch
enum gameState {dev, player}
var currentState = gameState.dev

# money should probably be somewhere else listening for signals
var money = 0

var keys = {
		"master": "!@#/", 
		"money": "!!$$",
		"emote": "!!@@",
		"item": "!!##",
		"mood": "!#mm"
		}


var testString = "Here's $400. !!$$:00400. don't spend it all at once"


func _ready():
	for i in keys.keys():
		testString = parse(testString)
	print(testString)
	if currentState == gameState.dev:
		parse("!@#/:00001")

func parse(toParse):
	var parsed = toParse
	for i in keys.keys():
		var j = keys[i]
		var from = parsed.find(j)  ## Find where in the string the code is
		if from > 0: 
			var amount = parsed.substr((from+5), 5) ##Work out what it is
			implement(i, amount.to_int()) ##And make the implement func take care of that
			
			parsed.erase(from, 11)  ##Remove the keycode
			break
	return parsed
	
	
	
func implement(attribute, amount):
	if attribute == "money":
		money += amount
		print(money)
	if attribute == "master":
		inMaster(amount)
		
func inMaster(code):
	print("dev mode active")
	pass
