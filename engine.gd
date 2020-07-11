extends Spatial

var constantDataPaths = {"items": "res://Data/items.json", "conversations":"res://Data/conversations.json"}
var constantData = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	loadFiles()
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
	pass
