extends Node2D


@onready var tile_map : Node2D = get_node("TileMap")
@onready var player   : CharacterBody2D = get_node("Player")

func _ready() -> void:
	player.clear_fog()
	tile_map.generate_chunk(player.global_position)
