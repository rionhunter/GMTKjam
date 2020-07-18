extends Control
class_name Achievement


var title : String
var value : int
var offset := Vector2()


func _ready():
	#call_deferred("$Label.set_text", "")
	pass


func update_label(add_value : int, new_offset := offset):
	print("updating label")
	value += add_value
	offset = new_offset
	_update_text()
	

func initialize_label(new_title : String, new_value := 0, new_offset := Vector2()):
	print("being called!")
	title = new_title
	if value:
		value += new_value
	else: 
		value = new_value
	
	_update_text()


func _update_text():
	print($Label.rect_position)
	#$Label.rect_position = offset
	$Label.set_text(title + ": " + str(value))


