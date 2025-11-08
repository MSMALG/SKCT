extends RichTextLabel


var defaultText = "PREV. RD SCORE: "

func _process(delta: float) -> void:
	var text = str(defaultText, str(Global.prevScore))
	self.text = (text)
