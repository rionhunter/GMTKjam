extends MeshInstance


func _ready():
	EventHub.connect("start_airlock", self, "_start_airlock")
	print("global wait pos: ", to_global($WaitPos.translation))
	print("wait pos: ", $WaitPos.translation)
	#print("using get global: ", $WaitPos.get_global_transform())

func _on_OutsideTrigger_body_entered(body):
	if body.get_name() == "Character":
		print("outside trigger enter")
		$Door.play()
		EventHub.emit_signal("outside_lock_triggered", to_global($WaitPos.translation))


func _on_OutsideTrigger_body_exited(body):
	if body.get_name() == "Character":
		print("outside trigger exit")
		$Door.play()


func _on_InsideTrigger_body_entered(body):
	if body.get_name() == "Character":
		print("inside trigger enter")
		$Door.play()
		EventHub.emit_signal("inside_lock_triggered", to_global($WaitPos.translation))



func _on_InsideTrigger_body_exited(body):
	if body.get_name() == "Character":
		print("inside trigger exit")
		$Door.play()
		
	
func _start_airlock():
	$Airlock.play()


func _on_Airlock_finished():
	EventHub.emit_signal("airlock_finished")

