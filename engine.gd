extends Spatial

var constantDataPaths = {"items": "res://Data/items.json", "conversations":"res://Data/conversations.json"}
var constantData = {}

onready var nav : Navigation = $Navigation
onready var character : KinematicBody = $Character
var patrol_index := 0


func _ready():
	loadFiles()
	#findPath() for debugging
	EventHub.connect("path_requested", self, "findPath")
	EventHub.connect("new_patrol_path", self, "newPatrolPath")
	setDestinations()


func loadFiles():
	var file = File.new()
	for i in constantDataPaths.keys():
		print(i)
#		file.open(JSON[constantDataPaths[i]], File.READ)
#		constantData.parse_json(file.get_as_text())
	file.close()
	print(constantData)


func findPath(new_destination := Vector3()):
	var new_path : PoolVector3Array
	new_path = nav.get_simple_path(character.to_global(self.translation), new_destination)
	character.path = new_path


func setDestinations():
	var dest_dict := {}
	var children = $Destinations.get_children()
	for node in children:
		dest_dict[node.get_name().to_lower()] = to_global(node.translation)
	$player.set_destinations(dest_dict)
	newPatrolPath()


func newPatrolPath():
	character.patrol_path = $ExplorationPaths.get_child(patrol_index).curve.get_baked_points()
	patrol_index = (patrol_index + 1) % $ExplorationPaths.get_child_count()
