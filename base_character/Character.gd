extends KinematicBody
class_name Character

var speed = 1.5
#var speed = 10


# TODO: get details on 3D environment to inform movement
var destination  = {"location": Spatial, "determined" : false, "embarked" : false}
var path : = PoolVector3Array() setget setPath
var x_direction := 1.0 # start out facing right
var z_direction := 1.0
var final_destination : Vector3
var is_inside := true
enum State {NORMAL, AIRLOCK}
var state = State.NORMAL
var patrol_path : PoolVector3Array setget setPatrolPath
var default_x_rotation := -42.24
var default_y_translation := 5.795
var potatoes := 0


func _ready():
#	destination["location"] = find_node("Desination")
#	destination["embarked"] = true
	EventHub.connect("animate", self, "_on_player_animation")
	EventHub.connect("new_destination", self, "_on_new_destination")
	EventHub.connect("inside_lock_triggered", self, "_on_inside_lock_triggered")
	EventHub.connect("outside_lock_triggered", self, "_on_outside_lock_triggered")
	EventHub.connect("airlock_finished", self, "_on_airlock_finished")
	EventHub.connect("start_exploring", self, "_on_start_exploring")
	EventHub.connect("entered_living_room", self, "_on_living_room_entered")
	EventHub.connect("exited_living_room", self, "_on_living_room_exited")
	EventHub.connect("greenhouse_entered", self, "_on_greenhouse_entered")
	EventHub.connect("greenhouse_exited", self, "_on_greenhouse_exited")
	EventHub.connect("potato_count", self, "update_potatoes")
	animate_sprite("idle")


func has_potatoes():
	if potatoes <= 0:
		return false
	return true


func update_potatoes(count : int):
	potatoes = count
	print("potatoes updated! ", count)


func _on_living_room_entered():
	$Camera.rotation_degrees.x = 0
	$Camera.translation.y = .5


func _on_living_room_exited():
	$Camera.rotation_degrees.x = default_x_rotation
	$Camera.translation.y = default_y_translation

func _on_greenhouse_entered():
	pass
	#$Camera.rotation_degrees.x = -25.0 # Still doesn't show mountains
	
func _on_greenhouse_exited():
	$Camera.rotation_degrees.x = default_x_rotation
	$Camera.translation.y = default_y_translation

func _process(delta):
	if destination["determined"]:
		var move_distance = speed * delta
		walk(move_distance)


func setPatrolPath(value : PoolVector3Array):
	patrol_path = value


func setPath(value : PoolVector3Array) -> void:
	path = value
	if value.size() == 0:
		return
	var last_point = path[len(path) - 1]
#	if last_point.distance_to(door_pos) < 0.1 and is_inside:
#		EventHub.emit_signal("reached_destination")
#		return
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
			_on_end_of_path()
			break

func _on_end_of_path():
	animate_sprite("idle")
	destination["embarked"] = false
	destination["determined"] = false
	if state == State.AIRLOCK:
		EventHub.emit_signal("start_airlock")
		state = State.NORMAL
	else:
		EventHub.emit_signal("reached_destination")


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
	final_destination = location
	if final_destination.distance_to(translation) < 0.1:
		EventHub.emit_signal("reached_destination")
	else:
		EventHub.emit_signal("path_requested", location)
	

func _wait_for_airlock(wait_loc : Vector3):
	EventHub.emit_signal("path_requested", wait_loc)
	state = State.AIRLOCK
	
	
func _on_airlock_finished():
	EventHub.emit_signal("path_requested", final_destination)


func _on_outside_lock_triggered(wait_loc : Vector3):
	# going left/outside
	if x_direction < 0: 
		return
		
	# going right/inside from the outside: wait for airlock first
	_wait_for_airlock(wait_loc)

func _on_inside_lock_triggered(wait_loc : Vector3):
	# going right/inside: already had airlock event
	if x_direction > 0: 
		is_inside = true
		EventHub.emit_signal("inside")
		return
		
	# going left/outside from the inside: wait for airlock first and put on helmet
	_wait_for_airlock(wait_loc) 
	is_inside = false
	EventHub.emit_signal("outside")


func _on_player_animation(anim : String):
	if anim == "explore":
		if patrol_path[len(patrol_path) - 1].distance_to(translation) < 0.1:
			EventHub.emit_signal("animation_done")
			EventHub.emit_signal("new_patrol_path")
		else:
			setPath(patrol_path)
		return
	if anim == "animal" and has_potatoes():
		$Sprite3D.flip_h = false
		$AnimationPlayer.play("helm_farm")
		return
	elif anim == "animal":
		$AnimationPlayer.play("helm_idle_right_down")
		yield(get_tree().create_timer(2), "timeout")
		EventHub.emit_signal("animation_done")
		return
	if anim == "note":
		if is_inside:
			$AnimationPlayer.play("note_inside")
		else:
			$AnimationPlayer.play("note_outside")
		return
	if $AnimationPlayer.has_animation(anim):
		$AnimationPlayer.play(anim)
		if anim == "entertainment":
			EventHub.emit_signal("watching_started")
			x_direction = 1
	else:
		print("I don't have the animation ", anim)
		print("I'm just going to do this")
		$AnimationPlayer.play("farm")


func _on_animation_finished():
	if $AnimationPlayer.current_animation == "entertainment":
		EventHub.emit_signal("watching_finished")
	animate_sprite("idle")
	EventHub.emit_signal("animation_done")
	

func _on_start_exploring():
	if len(patrol_path) <= 0:
		print("ERROR: no patrol path set")
		return
	final_destination = patrol_path[0]
	EventHub.emit_signal("new_destination", patrol_path[0])
	
