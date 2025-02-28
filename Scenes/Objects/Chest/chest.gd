class_name Chest extends StaticBody2D


@export var drop = {
	'diamonds': 100
}

@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")

var is_opened : bool = false

func _ready() -> void:
	animation_player.play('closed')

func open() -> void:
	animation_player.play('opened')
	for key in drop.keys():
		GlobalVars.player.inventory[key] += drop[key]
	
	is_opened = true
