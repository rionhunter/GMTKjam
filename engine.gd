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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func loadFiles():
	var file = File.new()
	for i in constantDataPaths.keys():
		print(i)
#		file.open(JSON[constantDataPaths[i]], File.READ)
#		constantData.parse_json(file.get_as_text())
	file.close()
	print(constantData)
	findPath()
	pass
	
func findPath():
	var new_path : = nav.get_simple_path(character.to_global(self.translation), destination.to_global(self.translation))
	character.path = new_path
