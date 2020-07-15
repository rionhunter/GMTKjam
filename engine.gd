extends Spatial

var constantDataPaths = {"items": "res://Data/items.json", "conversations":"res://Data/conversations.json"}
var constantData = {}

onready var nav : Navigation = $Navigation
onready var character : KinematicBody = $Character
onready var destination : Node = $Destination
# Called when the node enters the scene tree for the first time.
func _ready():
	loadFiles()
	destination = find_node("Destination")
	#findPath() for debugging
	EventHub.connect("path_requested", self, "findPath")
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
	if new_destination == Vector3():
		print("sending character to test destination")
		new_path = nav.get_simple_path(character.to_global(self.translation), destination.to_global(self.translation))
	else:
		new_path = nav.get_simple_path(character.to_global(self.translation), new_destination)
	character.path = new_path
	print("set the path!")
	
	
func setDestinations():
	$player.door_loc = $Door.to_global(self.translation)
	$player.window_loc = $Window.to_global(self.translation)
	$player.plant_loc = $Plant.to_global(self.translation)
	#$Character.house_pos = $Window.translation
	$Character.house_pos = $Window.to_global(self.translation)
	$Character.door_pos = $Door.to_global(self.translation)

