class_name Item extends StaticBody2D

@export var drop : Dictionary

var is_picked_up : bool = false

func pick_up() -> void:
	for key in drop.keys():
		GlobalVars.player.inventory[key] += drop[key]

	is_picked_up = true
	visible = false
