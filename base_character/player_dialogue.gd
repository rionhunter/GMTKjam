extends Dialogue


func _ready():
	._ready()
	EventHub.connect("player_speech", self, "_on_player_speech")
	

func _on_player_speech(text):
	$Label.text = text
	$AnimationPlayer.play("show")
