extends Node
class_name Plant

enum plantStates {soil, sowed, sapling, growing, grown, fruiting}

var plant_model := {} # For storing mesh instances of the different plant stages

var hydration := 5.0
const hydration_max := 10.0
const hydration_dec := 1.0
var state = plantStates.soil
const plant_yield_max := 5
var current_yield:= 5


func tend_plant():
	# Down the line this would probably be different, but just doing all the 
	# farm maintenance tasks at once with the "farm" action
	water()
	harvest()
	sow()


func sow():
	if state != plantStates.soil:
		return
	current_yield = plant_yield_max
	$Timer.start()
	EventHub.emit_signal("sowed")
	print("plant sowed")
	state = plantStates.sowed


func harvest():
	if state != plantStates.fruiting:
		return
	EventHub.emit_signal("harvested", current_yield)
	state = plantStates.soil
	_update_mesh()


func needs_tending() -> bool:
	# Not currently called
	if hydration <= 5.0 or state == plantStates.soil or state == plantStates.fruiting: 
		return true
	else:
		return false


func water():
	hydration = hydration_max
	EventHub.emit_signal("watered")
	print("plant watered")

func _ready():
	plant_model[plantStates.soil] = preload("res://Environment/plants/soil.tscn").instance()
	plant_model[plantStates.sapling] = preload("res://Environment/plants/Potato/potato_sapling.tscn").instance()
	plant_model[plantStates.grown] = preload("res://Environment/plants/Potato/potato_mid.tscn").instance()
	plant_model[plantStates.fruiting] = preload("res://Environment/plants/Potato/potato_final.tscn").instance()
	EventHub.connect("tended_plants", self, "tend_plant")


func _on_Timer_timeout():
	if state == plantStates.soil or state == plantStates.fruiting:
		return
	state = state + 1
	print("plant state now: ", state)
	_update_mesh() # Changes model as appropriate
	hydration -= hydration_dec
	_check_state()
	$Timer.start() # Restarts timer for next stage of growth


func _check_state():
	# More for down the line, when there's a "dead plant" object: plants could die
	# if not looked after (e.g. not watered)
	
	# Decreases plant's yield if unwatered (function not called when state is fruiting)
	if hydration <= 3.0:
		current_yield = max(current_yield - 1, 1)


func _update_mesh():
	# Plant starts out as soil mesh instance, then gets updated according to 
	# the current state (if there's a model for the current state)
	if plant_model.has(state):
		$MeshInstance.replace_by(plant_model[state])
