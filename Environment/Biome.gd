extends Area

enum biomeTypes {swamp, forest, plain, desert}
export var biome = biomeTypes.plain

# Called when the node enters the scene tree for the first time.
func _ready():
	print(biome)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
