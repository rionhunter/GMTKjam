extends Control


var offset = Vector2(10, 10)
var notes_collected := 0


func _ready():
	visible = false
	EventHub.connect("game_started", self, "_on_game_start")
	EventHub.connect("note_detected", self, "_on_note_detected")


func _on_game_start():
	#$Achievement.initialize_label("Notes collected", 0, offset)
	visible = true


func _on_note_detected():
	$AudioStreamPlayer.play()
	notes_collected += 1
	$NotesCollected/Value.text = str(notes_collected)
