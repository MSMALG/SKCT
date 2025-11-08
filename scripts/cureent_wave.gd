extends RichTextLabel

var defaultText = "CURRENT WAVE: "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var text = str(defaultText, str(Global.current_wave))
	self.text = (text)
