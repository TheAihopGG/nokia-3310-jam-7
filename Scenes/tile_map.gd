extends Node2D


@onready var layer_wall : TileMapLayer = get_node("LayerWall")

func map_to_local(pos : Vector2i) -> Vector2:
    return layer_wall.map_to_local(pos)

func local_to_map(pos : Vector2) -> Vector2i:
    return layer_wall.local_to_map(pos)
