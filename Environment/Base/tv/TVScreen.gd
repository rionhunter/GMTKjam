extends Spatial
# TODO: get sprite updates to fix frame issues and add all anims

const channels := ["potato", "housewives", "news", "beauty", "talent"]
var is_on := false
var rng := RandomNumberGenerator.new()
var next_channel : String


func _ready():
	EventHub.connect("watching_started", self, "turn_on")
	EventHub.connect("watching_finished", self, "turn_off")
	$AnimationPlayer.play("idle")
	next_channel = get_random_channel()


func turn_on():
	# Plays static and assigns a random channel to play after the static anim finishes
	is_on = true
	play_next()
	$Timer.start() 


func turn_off():
	is_on = false
	$Timer.stop()
	$AnimationPlayer.play("turn_off")


func get_random_channel() -> String:
	var index = rng.randi_range(0, len(channels) - 1)
	return channels[index]
	

func play_next():
	if !is_on: # stay idle
		return
#	if $AnimationPlayer.get_current_animation() == next_channel: # already playing
#		return
	if $AnimationPlayer.has_animation(next_channel): 
		$AnimationPlayer.play(next_channel)
	else:
		$AnimationPlayer.play("static") # don't have that animation
	next_channel = get_random_channel()

func _on_Timer_timeout():
	if $AnimationPlayer.get_current_animation() == next_channel: # already playing
		next_channel = get_random_channel()
		return
	else:
		$AnimationPlayer.play("static")



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != "static":
		return
	play_next()
