extends Area




func _on_Area_body_entered(body):
	if body.get_name() == "Character":
		EventHub.emit_signal("entered_living_room")


func _on_Area_body_exited(body):
	if body.get_name() == "Character":
		EventHub.emit_signal("exited_living_room")
