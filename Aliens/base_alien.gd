extends KinematicBody
class_name Alien


var phrases := {}
var rng = RandomNumberGenerator.new()
var character_in_range := true
var is_enabled := true
var waiting_for_reply := false
var player_has_spoken := false
var no_response_periods := 0
var quest_keyword := "deerp"
var quest_accepted := false
var quest_help_index := 0


func random_response(category : String):
	if !phrases.has(category):
		print("no phrases found for: ", category)
		return
	var responses = phrases[category]
	var i = rng.randi_range(0, len(responses)-1)
	$Dialogue.set_and_show(responses[i])


func greet():
	random_response("GREETING")
	yield(get_tree().create_timer(4), "timeout")
	$Dialogue.set_and_show("I moved in down the planet")
	yield(get_tree().create_timer(4), "timeout")
	$Dialogue.set_and_show("I'm X AE A-XIII")
	yield(get_tree().create_timer(4), "timeout")
	$Dialogue.set_and_show("Wanna hang out some time?")
	$Timer.start()	
	waiting_for_reply = true

func say_goodbye():
	random_response("GOODBYE")
	waiting_for_reply = false
	$Timer.stop()


func _on_player_finished_speaking(input : String):
	$Timer.start(15)
	player_has_spoken = true
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
			print("category: ", category)
			if phrases.has(category):
				random_response(category)
				if category == "AFFIRMATIVE":
					EventHub.emit_signal("game_over")
					$Timer.stop()
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
	#$AnimationPlayer.play("hidden")
	$Sprite3D.visible = false
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
		

func _on_appeared():
	greet()
	$AnimationPlayer.play("idle")


func _on_Timer_timeout():
	var response = ""
	if !player_has_spoken:
		response = phrases["NO_RESPONSE"][no_response_periods % len(phrases["NO_RESPONSE"])]
	else:
		random_response("MISC")
		return
	$Dialogue.set_and_show(response)
	no_response_periods += 1


func _on_Alien_tree_entered():
	$AnimationPlayer.play("appear")
	yield(get_tree().create_timer(3), "timeout")
	EventHub.emit_signal("alien_arrived")
