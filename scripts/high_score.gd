extends RichTextLabel


var defaultText = "HIGH SCORE: "

func _process(delta: float) -> void:
	var text = str(defaultText, str(Global.highScore))
	self.text = (text)
