class_name Dialog extends Label

@export var text_speech_speed : float = 0.1

@onready var timer : Timer = get_node("Timer")
@onready var parent : Character = get_parent()

var texts : Array[String]

func _say(texts_to_say : Array[String]) -> void:
	texts = texts_to_say
	timer.start(0)

func _on_timer_timeout() -> void:
	if texts:
		text = texts[0]
		timer.start(len(texts[0]) * text_speech_speed)
		texts.remove_at(0)
		visible = true
	
	else:
		visible = false
