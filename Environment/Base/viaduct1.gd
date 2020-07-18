extends MeshInstance
class_name Viaduct


var needs_airlock := true


func _ready():
	EventHub.connect("start_airlock", self, "_start_airlock")


func _on_OutsideTrigger_body_entered(body):
	if body.get_name() == "Character":
		$Door.play()
		if needs_airlock:
			EventHub.emit_signal("outside_lock_triggered", to_global($WaitPos.translation))


func _on_OutsideTrigger_body_exited(body):
	if body.get_name() == "Character":
		$Door.play()


func _on_InsideTrigger_body_entered(body):
	if body.get_name() == "Character":
		$Door.play()
		if needs_airlock:
			EventHub.emit_signal("inside_lock_triggered", to_global($WaitPos.translation))


func _on_InsideTrigger_body_exited(body):
	if body.get_name() == "Character":
		$Door.play()
		
	
func _start_airlock():
	$Airlock.play()


func _on_Airlock_finished():
	EventHub.emit_signal("airlock_finished")

