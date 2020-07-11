extends TextEdit

signal new_input

# The associated color for each type of keyword
const AGGRESSION := Color(1, 0.13, 0.13)
const AFFECTION := Color(0.85, 0.33, 1)
const EXPLORATION := Color(0.15, 0.71, 0.64)


func _ready():
	for word in Keywords.dir:
		set_keyword_color(word)


func set_keyword_color(word : String) -> void:
	var color : Color
	match Keywords.dir[word]:
		Keywords.Category.AGGRESSION:
			color = AGGRESSION
		Keywords.Category.AFFECTION:
			color = AFFECTION
		Keywords.Category.EXPLORATION:
			color = EXPLORATION
	add_keyword_color(word, color)


func _input(_event):
	if Input.is_key_pressed(KEY_ENTER):
		# Enter key is one way to send typed input # TODO: add button as well
		get_tree().set_input_as_handled()
		process_input(text)
		reset()


func reset():
	text = ""


func process_input(input : String) -> void:
	print("Input received: ", input)
	var words = input.split(" ")
	var input_dir = new_category_dir()
	for word in words:
		if get_keyword_color(word) != Color():
			var category = Keywords.dir[word]
			input_dir[category] = input_dir[category] + 1
	print("keyword counts: ", input_dir)
	emit_signal("new_input", input_dir)


func new_category_dir():
	var dir = {}
	for category in Keywords.Category:
		dir[Keywords.Category[category]] = 0
	return dir
		
