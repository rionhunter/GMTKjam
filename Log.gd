extends TextEdit

func _on_Input_new_input(input : String):
	insert_text_at_cursor(">" + input + "\n")
	print("cursor position: ", cursor_get_line())
