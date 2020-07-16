extends Spatial


const animations := ["potato", "housewives", "news"]
var is_on := false
var rng := RandomNumberGenerator.new()


func _ready():
	EventHub.connect("watching_started", self, "turn_on")
	EventHub.connect("watching_finished", self, "turn_off")
	turn_off()


func turn_on():
	is_on = true
	$AnimatedSprite3D.visible = true
	choose_random_channel()
	$Timer.start()


func turn_off():
	is_on = false
	$Timer.stop()
	$AnimatedSprite3D.stop()
	$AnimatedSprite3D.visible = false
	$AnimatedSprite3D.set_frame(0)


func choose_random_channel():
	if !is_on:
		return
	var index = rng.randi_range(0, len(animations) - 1)
	var channel = animations[index]
	if $AnimatedSprite3D.get_animation() == channel:
		return
	else:
		$AnimatedSprite3D.stop()
		$AnimatedSprite3D.set_frame(0)
		$AnimatedSprite3D.play(channel)


func _on_Timer_timeout():
	choose_random_channel()
