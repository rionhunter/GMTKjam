extends KinematicBody
class_name Character

var speed = 1.5


# TODO: get details on 3D environment to inform movement
var destination  = {"location": Spatial, "determined" : false, "embarked" : false}
var path : = PoolVector3Array() setget setPath
var x_direction := 1.0 # start out facing right



func _ready():
#	destination["location"] = find_node("Desination")
#	destination["embarked"] = true
	EventHub.connect("in_house", self, "_on_house_entry")
	EventHub.connect("outside", self, "_on_house_exit")
	EventHub.connect("animate", self, "_on_player_animation")
	animate_sprite("idle")
	
func _process(delta):
	if destination["determined"]:
		var move_distance = speed * delta
		walk(move_distance)

func setPath(value : PoolVector3Array) -> void:
	path = value
	if value.size() == 0:
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
			print("idle now")
			break
		
func animate_sprite(animation : String):
	match animation:
		"walk":
			if x_direction >= 0:
				$AnimationPlayer.play("helm_walk_right_down")
			else:
				$AnimationPlayer.play("helm_walk_left_up")
		"idle":
			if x_direction >= 0:
				$AnimationPlayer.play("helm_idle_right_down")
			else:
				$AnimationPlayer.play("helm_idle_left_up")
			
func _on_house_entry():
	$Sprite3D.visible = false


func _on_house_exit():
	$Sprite3D.visible = true
	
	
func _on_player_animation(anim : String):
	match anim:
		"work":
			print("working!")
			$AnimationPlayer.play("work")
		_:
			print("I don't have that animation")
			print("I'm just going to do this")
			$AnimationPlayer.play("work")
			

func _on_animation_finished():
	animate_sprite("idle")
	EventHub.emit_signal("animation_done")
