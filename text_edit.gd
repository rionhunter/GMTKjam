extends TextEdit

signal new_input
signal new_keywords


func _input(_event):
	if Input.is_key_pressed(KEY_ENTER):
		# Enter key is one way to send typed input # TODO: add button as well
		get_tree().set_input_as_handled()
		process_input(text.to_lower())
		reset()


func reset():
	text = ""


func process_input(input : String) -> void:
	print("Input received: ", input)
	emit_signal("new_input", input)
	var words = input.split(" ")
	var input_dir = new_category_dir()
	var keywords = []
	for word in words:
		if get_keyword_color(word) != Color(): # If it is a keyword
			var category = Keywords.dir[word]
			input_dir[category] = input_dir[category] + 1
			keywords.append(word)
	print("keyword counts: ", input_dir)
	
	# Not sure which one to use ;; might use both, depending
	emit_signal("new_keywords", keywords)
	emit_signal("keyword_counts", input_dir)


func new_category_dir():
	var dir = {}
	for category in Keywords.Category:
		dir[Keywords.Category[category]] = 0
	return dir	
