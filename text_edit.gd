extends TextEdit

signal new_input


func _ready():
	grab_focus()


func _input(_event):
	if Input.is_key_pressed(KEY_ENTER):
		# Enter key is one way to send typed input # TODO: add button as well
		get_tree().set_input_as_handled()
		process_input(text.to_lower())
		reset()


func reset():
	text = ""

func invalid_input():
	# TODO: add feedback noise if entering blank string
	$AudioStreamPlayer.play()

func process_input(input : String) -> void:
	if input == "":
		invalid_input()
		return
	
	emit_signal("new_input", input)
	
	# Debugging commands
	if input == "stats":
		EventHub.emit_signal("stat_check")
	if input == "queue":
		EventHub.emit_signal("queue_check")
	
	var original_input = input
	
	input = input.replace("?", " ")
	input = input.replace(",", " ")
	input = input.replace(".", " ")
	var words = input.split(" ")
	var input_dir = {}
	
	# Tags any input starting with "say" or that is bookended with quotation marks
	#      and passes this text to player's dialogue node
	# TODO: have separate commands list that get processed in a function?
	if original_input.begins_with("say"):
		if original_input == "say":
			EventHub.emit_signal("new_thought", "say what?")
		else:
			EventHub.emit_signal("player_speech", original_input.substr(3))
		return
	elif original_input.ends_with("out loud"):
		var end_index = original_input.find_last("out loud")
		if end_index == 0:
			EventHub.emit_signal("new_thought", "say what out loud?")
		else:
			EventHub.emit_signal("player_speech", original_input.substr(0,end_index - 1))
		return
	elif original_input[0] == '"' and original_input[-1] == '"':
		EventHub.emit_signal("player_speech", original_input.substr(1, len(original_input)-2))
		return


	for word in words:
		if has_keyword_color(word): # If it is a keyword
			if !input_dir.has(word):
				input_dir[word] = 1
			else:
				input_dir[word] = input_dir[word] + 1
	
	if !input_dir:
		EventHub.emit_signal("meaningless_input")
	else:
		EventHub.emit_signal("new_keywords", input_dir)
