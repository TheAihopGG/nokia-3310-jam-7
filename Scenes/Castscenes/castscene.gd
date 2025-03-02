class_name Castscene extends Node2D

@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")

func _process(_delta: float) -> void:
	if Input.is_anything_pressed():
		sprite.frame += 1
