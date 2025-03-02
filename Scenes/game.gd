extends Node2D


@onready var tile_map : Node2D = get_node("TileMap")
@onready var player   : CharacterBody2D = get_node("Player")
@onready var selected : Sprite2D = get_node("Selected")


func _ready() -> void:
	player.clear_fog()
	tile_map.generate_chunk(player.global_position)

func _physics_process(_delta: float) -> void:
	if is_instance_valid(player) and player.move_direction:
		selected.global_position = tile_map.map_to_local(tile_map.local_to_map(player.hitbox.global_position))
