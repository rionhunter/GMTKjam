extends Dialogue


func _ready():
	._ready()
	EventHub.connect("player_speech", self, "_on_player_speech")
	

func _on_player_speech(text):
	$Label.text = text
	$AnimationPlayer.play("show")
	

func _on_text_displayed():
	._on_text_displayed()
	EventHub.emit_signal("speech_finished", $Label.text)
