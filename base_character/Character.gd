extends KinematicBody
class_name Character

var speed = 1.5
#var speed = 10


# TODO: get details on 3D environment to inform movement
var destination  = {"location": Spatial, "determined" : false, "embarked" : false}
var path : = PoolVector3Array() setget setPath
var x_direction := 1.0 # start out facing right
var z_direction := 1.0
var house_pos : Vector3
var door_pos : Vector3
var final_destination : Vector3
var is_inside := false


func _ready():
#	destination["location"] = find_node("Desination")
#	destination["embarked"] = true
	EventHub.connect("door", self, "_on_door_triggered")
	EventHub.connect("animate", self, "_on_player_animation")
	EventHub.connect("new_destination", self, "_on_new_destination")
	animate_sprite("idle")
	
func _process(delta):
	if destination["determined"]:
		var move_distance = speed * delta
		walk(move_distance)

func setPath(value : PoolVector3Array) -> void:
	path = value
	if value.size() == 0:
		return
	var final_destination = path[len(path) - 1]
	if final_destination.distance_to(door_pos) < 0.1 and is_inside:
		EventHub.emit_signal("reached_destination")
		return
	destination["determined"] = true

func walk(distance : float) -> void:
	# TODO: implement movement with move_and_slide since KinematicBody?
	var embarked = destination["embarked"]
	destination["embarked"] = true
	var last_position : = self.translation
	for i in range(path.size()):
		animate_sprite("walk")
		var distance_to_next : = last_position.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0:
			x_direction = self.transform.origin.direction_to(path[0]).x
			z_direction = self.transform.origin.direction_to(path[0]).z
			self.transform.origin = last_position.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance == 0: # currently does not get called
			self.transform.origin = path[0]
			destination["embarked"] = false
			animate_sprite("idle")
			break
		distance -= distance_to_next
		last_position = path[0]
		path.remove(0)
		if path.size() == 0: #bandaid solution; may be better way of doing
			animate_sprite("idle")
			destination["embarked"] = false
			destination["determined"] = false
			EventHub.emit_signal("reached_destination")
			break
		
func animate_sprite(animation : String):
	if is_inside:
		_inside_animation(animation)
	else:
		_outside_animation(animation)

func _inside_animation(animation : String):
	match animation:
		"walk":
			# First two are most straightforward cases
			if x_direction >= 0 and z_direction >= 0:
				$Sprite3D.flip_h = false
				$AnimationPlayer.play("walk_right_down")
			elif x_direction < 0 and z_direction < 0:
				$Sprite3D.flip_h = false
				$AnimationPlayer.play("walk_left_up")
			elif abs(z_direction) > x_direction:
				$Sprite3D.flip_h = true
				if z_direction > 0:
					$AnimationPlayer.play("walk_right_down")
				else:
					$AnimationPlayer.play("walk_left_up")
			elif x_direction > 0:
				$Sprite3D.flip_h = false
				$AnimationPlayer.play("walk_right_down")
			else:
				$AnimationPlayer.play("walk_left_up")
		"idle":
			if x_direction >= 0:
				$AnimationPlayer.play("idle_right_down")
			else:
				$AnimationPlayer.play("idle_left_up")


func _outside_animation(animation : String):
	match animation:
		"walk":
			# First two are most straightforward cases
			if x_direction >= 0 and z_direction >= 0:
				$Sprite3D.flip_h = false
				$AnimationPlayer.play("helm_walk_right_down")
			elif x_direction < 0 and z_direction < 0:
				$Sprite3D.flip_h = false
				$AnimationPlayer.play("helm_walk_left_up")
			elif abs(z_direction) > x_direction:
				$Sprite3D.flip_h = true
				if z_direction > 0:
					$AnimationPlayer.play("helm_walk_right_down")
				else:
					$AnimationPlayer.play("helm_walk_left_up")
			elif x_direction > 0:
				$Sprite3D.flip_h = false
				$AnimationPlayer.play("helm_walk_right_down")
			else:
				$AnimationPlayer.play("helm_walk_left_up")
		"idle":
			if x_direction >= 0:
				$AnimationPlayer.play("helm_idle_right_down")
			else:
				$AnimationPlayer.play("helm_idle_left_up")
			

func _on_new_destination(location : Vector3):
	# TODO: allow for in-base destinations
	final_destination = location
	if final_destination.distance_to(translation) < 0.1:
		EventHub.emit_signal("reached_destination")
	elif is_inside:
		is_inside = false
		use_door()
	else:
		EventHub.emit_signal("path_requested", location)
	
	
func _on_door_triggered():
	if $DoorCreak.playing:
		return
	print("inside is ", is_inside)
	if is_inside:
		is_inside = false
	else:
		is_inside = true
	use_door()


func use_door():
	$Sprite3D.visible = false
	if path:
		path = []
		if is_inside:
			translation = final_destination
			#EventHub.emit_signal("new_destination", final_destination)
		# TODO: make it so character can navigate inside the ship

	if !is_inside:
		translation = door_pos
		EventHub.emit_signal("path_requested", final_destination)
	$DoorCreak.play()
	animate_sprite("idle")
	print("inside is ", is_inside)


func _on_DoorCreak_finished():
	$Sprite3D.visible = true
	if is_inside:
		print("reached indoors destination")
		EventHub.emit_signal("reached_destination")
	print("inside is ", is_inside)


func _on_player_animation(anim : String):
	if $AnimationPlayer.has_animation(anim):
		$AnimationPlayer.play(anim)
	else:
		print("I don't have the animation ", anim)
		print("I'm just going to do this")
		$AnimationPlayer.play("work")


func _on_animation_finished():
	animate_sprite("idle")
	EventHub.emit_signal("animation_done")
	

