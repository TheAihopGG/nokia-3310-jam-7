class_name Chest extends StaticBody2D


@export var drop = {
	'diamonds': 100
}

@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")

var is_opened : bool = false

func _ready() -> void:
	animated_sprite.play('closed')

func open() -> void:
	animated_sprite.play('opened')
	for key in drop.keys():
		GlobalVars.player.inventory[key] += drop[key]
	
	is_opened = true
