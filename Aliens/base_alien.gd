extends KinematicBody
class_name Alien


var phrases := {}
var rng = RandomNumberGenerator.new()
var character_in_range := false
# TODO: 
# basic movement
# connect to player speech finished signal (also make that signal)
# say something when spoken to
# randomly greet even if not spoken to? -> e.g. "aren't you going to say something?" (and if not, do something like "rude!")
					# saying "something" should yield a specific response / set of responses
# "talk to alien" -> "go to alien" (nearest alien?) + "what should I say?"

# Call goodbye function when leaves area or when player says goodbye? starts timer to reset a bool value?


func random_response(category : String):
	if !phrases.has(category):
		print("no phrases found for: ", category)
		return
	var responses = phrases[category]
	var i = rng.randi_range(0, len(responses)-1)
	$Dialogue.set_and_show(responses[i])


func _on_player_finished_speaking(input : String):
	input = input.replace("?", " ")
	input = input.replace(",", " ")
	input = input.replace(".", " ")
	var words = input.split(" ")
	
	for word in words:
		if Keywords.dir.has(word):
			var category = Keywords.dir[word]
			if phrases.has(category):
				random_response(category)
				return


func _ready():
	# Open and parse response lines
	var file = File.new()
	file.open("res://Aliens/base_dialogue.json", file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	phrases = result_json.result
	file.close()
	
	EventHub.connect("speech_finished", self, "_on_player_finished_speaking")


func _on_Area_body_entered(body):
	if body.get_name() == "Character":
		character_in_range = true


func _on_Area_body_exited(body):
	if body.get_name() == "Character":
		character_in_range = false

