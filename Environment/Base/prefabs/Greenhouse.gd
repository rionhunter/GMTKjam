extends Area


func _on_Area_body_entered(body):
	if body.get_name() =="Character":
		EventHub.emit_signal("greenhouse_entered")


func _on_Area_body_exited(body):
	if body.get_name() =="Character":
		EventHub.emit_signal("greenhouse_exited")
