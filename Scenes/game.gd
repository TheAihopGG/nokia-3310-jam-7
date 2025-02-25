extends Node2D


@onready var selected    : Sprite2D = get_node("%Select")
@onready var tile_map    : Node2D = get_node("TileMap")


func _input(_event: InputEvent) -> void:
	#var selected_tile : Vector2 = tile_map.map_to_local(tile_map.local_to_map(get_global_mouse_position()))
	#selected.global_position = selected_tile
	pass
