extends TextEdit
class_name Log
"""
TextEdit node responsible for showing stream of consciousness, both player inputs
and character thoughts and actions
"""

func _ready():
	EventHub.connect("new_thought", self, "_on_Player_new_thought")
	EventHub.connect("new_action", self, "_on_Player_new_action")
	

func set_cursor():
	# Function resets cursor to last line so player input doesn't affect output
	cursor_set_line(get_line_count() - 1)


func _on_Input_new_input(input : String):
	set_cursor()
	insert_text_at_cursor(">>" + input + "<<" + "\n")
	

func _on_Player_new_thought(thought : String):
	set_cursor()
	insert_text_at_cursor(thought + "\n")


func _on_Player_new_action(action: String):
	set_cursor()
	insert_text_at_cursor("[[*" + action + "*]]" + "\n")


