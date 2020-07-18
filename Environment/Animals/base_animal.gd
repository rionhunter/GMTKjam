extends Spatial
export(bool) var flip


var rng = RandomNumberGenerator.new()


func _ready():
	$AnimationPlayer.play("idle")
	$Sprite3D.flip_h = flip


func _on_Area_body_entered(body):
	if body.get_name() == "Character":
		disappear()
		pass

func disappear():
	$AnimationPlayer.play("hide")
	$AudioStreamPlayer.play()


func _on_hidden():
	queue_free()


func _on_Timer_timeout():
	var anim = $AnimationPlayer.current_animation
	if anim == "hide":
		return
	elif anim == "idle":
		$AnimationPlayer.play("eat")
	else:
		$AnimationPlayer.play("idle")
		
	$Timer.start(rng.randi_range(3, 8))	
