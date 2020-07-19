extends Spatial
export(bool) var flip
var reappear_time := 30.0


var rng = RandomNumberGenerator.new()


func _ready():
	$AnimationPlayer.play("idle")
	$Sprite3D.flip_h = flip


func _on_Area_body_entered(body):
	if body.get_name() != "Character":
		return
	if !body.has_potatoes():
		disappear()
		EventHub.emit_signal("scared_animal")
	else:
		EventHub.emit_signal("fed_animal")
		$AnimationPlayer.play("eat")


func disappear():
	$AnimationPlayer.play("hide")
	$AudioStreamPlayer.play()
	$Timer.stop()


func reappear():
	print("reappearing")
	$AnimationPlayer.play("appear")
	$Timer.start()
	

func _on_hidden():
	yield(get_tree().create_timer(reappear_time), "timeout")
	reappear()


func _on_Timer_timeout():
	var anim = $AnimationPlayer.current_animation
	if anim == "hide":
		return
	elif anim == "idle":
		$AnimationPlayer.play("eat")
	else:
		$AnimationPlayer.play("idle")
		
	$Timer.start(rng.randi_range(3, 8))	
