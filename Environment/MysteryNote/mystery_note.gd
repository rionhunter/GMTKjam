extends Spatial

# Unsure if we want the notes picked up to be random, or in a certain order (or if we even want to stick with notes)
#var text = ("Day 1: the locals aren't hostile, but they are ambivalent. " 
#			+ "Every attempt at socializing is met with abject disinterest. "
#			+ "Tomorrow I will try my best anecdote, but I fear it will not be enough")

func _on_Area_body_entered(body):
	if body.get_name() == "Character":
		#EventHub.emit_signal("note_detected", text)
		EventHub.emit_signal("note_detected")
		queue_free()
