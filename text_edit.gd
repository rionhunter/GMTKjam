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


func process_input(input : String) -> void:
	emit_signal("new_input", input)
	
	# Debugging commands
	if input == "stats":
		EventHub.emit_signal("stat_check")
	if input == "queue":
		EventHub.emit_signal("queue_check")
	
	input = input.replace("?", " ")
	input = input.replace(",", " ")
	input = input.replace(".", " ")
	var words = input.split(" ")
	var input_dir = {}
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
