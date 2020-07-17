extends Control

## Text Input ##
var first_input := true # For removing ColorRect on input

## Game state control ##
# a dev switch
enum gameState {dev, player}
var currentState = gameState.dev

# money should probably be somewhere else listening for signals
var money = 0

const NORMAL := Color(1, 1, 1) # White

# The associated color for each type of keyword
const AGGRESSION := Color(1, 0.13, 0.13)
const AFFECTION := Color(0.85, 0.33, 1)
const FOOD := Color(0.44, 0.81, 0.5)
const MAINTENANCE := Color(0.53, 0.75, 0.88)

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
	if currentState == gameState.dev:
		parse("!@#/:00001")
	initialize_text_fields()
	$AnimationPlayer.play("screen_appear")


func initialize_text_fields() -> void:
	$Input.modulate = NORMAL
	$Log.modulate = NORMAL
	set_keyword_colors()


func set_keyword_colors() -> void:
	var color = Color()
	for word in Keywords.dir:
		match Keywords.dir[word]:
			Keywords.Category.AGGRESSION:
				color = AGGRESSION
			Keywords.Category.AFFECTION:
				color = AFFECTION
			Keywords.Category.FOOD:
				color = FOOD
			Keywords.Category.MAINTENANCE:
				color = MAINTENANCE
			_:
				color = NORMAL
		$Input.add_keyword_color(word, color)
		$Log.add_keyword_color(word, color)


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
	if attribute == "master":
		inMaster(amount)


func inMaster(code):
	pass


func _on_Input_new_input(_input):
	print("input!")
	if first_input:
		remove_screen()
		first_input = false


func remove_screen():
	$AnimationPlayer.play("screen_disappear")
