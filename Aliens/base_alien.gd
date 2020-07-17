extends KinematicBody
class_name Alien


var phrases := {}
var rng = RandomNumberGenerator.new()
var character_in_range := false
var is_enabled := false
var waiting_for_reply := false
var no_response_periods := 0
var quest_keyword := "deerp"
var quest_accepted := false
var quest_help_index := 0
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
#	if "deerp" in responses[i]:



func greet():
	random_response("GREETING")
	$Timer.start()	
	waiting_for_reply = true

func say_goodbye():
	random_response("GOODBYE")
	waiting_for_reply = false
	$Timer.stop()


func _on_player_finished_speaking(input : String):
	$Timer.stop()
	no_response_periods = 0
	
	if quest_keyword in input:
		_on_quest_keyword()
		return
		
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
	random_response("MISC")


func _on_quest_keyword():
	var response := ""
	if !quest_accepted: 
		response = phrases["QUEST_GIVE"][0]
	else:
		response = phrases["QUEST_HELP"][quest_help_index]
		quest_help_index = (quest_help_index + 1) % len(phrases["QUEST_HELP"])
		
func _ready():
	# Open and parse response lines
	$AnimationPlayer.play("idle")
	
	var file = File.new()
	file.open("res://Aliens/base_dialogue.json", file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	phrases = result_json.result
	file.close()
	
	EventHub.connect("speech_finished", self, "_on_player_finished_speaking")
	EventHub.connect("game_started", self, "_on_game_started")


func _on_Area_body_entered(body):
	if body.get_name() == "Character":
		character_in_range = true
		if is_enabled:
			greet()


func _on_Area_body_exited(body):
	if body.get_name() == "Character":
		character_in_range = false
		if is_enabled:
			say_goodbye()


func _on_game_started():
	is_enabled = true
	if character_in_range:
		greet()


func _on_Timer_timeout():
	if !waiting_for_reply or no_response_periods >= len(phrases["NO_RESPONSE"]):
		$Timer.stop()
		return
	var response = phrases["NO_RESPONSE"][no_response_periods]
	$Dialogue.set_and_show(response)
	no_response_periods += 1
