extends Spatial
export(bool) var flip


func _ready():
	$AnimationPlayer.play("idle")
	$Sprite3D.flip_h = flip


func _on_Area_body_entered(body):
	if body.get_name() == "Character":
		disappear()


func disappear():
	$AnimationPlayer.play("hide")
	$AudioStreamPlayer.play()


func _on_hidden():
	queue_free()
