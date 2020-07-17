extends Spatial
class_name Dialogue


var y_offset := -75.0
var x_offset := -250.0


func _ready():
	set_process(true)
	$AnimationPlayer.play("hide")


func _process(_delta):
	#print("I'm here!")
	var pos = to_global(translation)
	var cam = get_tree().get_root().get_camera()
	var screen_pos = cam.unproject_position(pos)
	$Label.rect_position = Vector2(screen_pos.x + x_offset, screen_pos.y + y_offset)


func _on_text_displayed():
	$AnimationPlayer.play("hide")
