extends KinematicBody
class_name Character

var speed = 3.0


# TODO: get details on 3D environment to inform movement
var destination  = {"location": Spatial, "determined" : false, "embarked" : false}
var path : = PoolVector3Array() setget setPath



func _ready():
	destination["location"] = find_node("Desination")
	destination["embarked"] = true
	
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
	var embarked = destination["embarked"]
	embarked = true
	var last_position : = self.translation
	for i in range(path.size()):
		var distance_to_next : = last_position.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			self.transform.origin = last_position.linear_interpolate(path[0], distance / distance_to_next)
			break
		elif distance <= 0:
			self.transform.origin = path[0]
			embarked = false
			print(embarked)
			break
		distance -= distance_to_next
		last_position = path[0]
		path.remove(0)
