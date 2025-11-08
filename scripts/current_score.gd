extends RichTextLabel

var defaultText = "CURRENT SCORE: "

func _process(delta: float) -> void:
	var text = str(defaultText, str(Global.currentScore))
	self.text = (text)
