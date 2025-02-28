extends Node2D


@onready var tile_map : Node2D = get_node("TileMap")


func _on_threaded_tilemap_gaea_renderer_area_rendered(area: Rect2i) -> void:
    if area.size:
        tile_map.generate_chunk()
