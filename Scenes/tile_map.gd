extends Node2D


@onready var layer_floor : TileMapLayer = get_node("LayerFloor")
@onready var layer_wall  : TileMapLayer = get_node("LayerWall")
@onready var layer_fog   : TileMapLayer = get_node("LayerFog")

const LIST_LAND : Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]

var list_vectors : Array[Vector2i] = get_array_circle(4)

func _ready() -> void:
    layer_fog.show()
    _tilemap_matrix_generation()
    
func _tilemap_matrix_generation() -> void:
     # полные размеры карты и координаты начального тайла
    var region_size     : Vector2i = layer_wall.get_used_rect().size
    var region_position : Vector2i = layer_wall.get_used_rect().position
    
    for x in region_size.x:
        for y in region_size.y:
            # позиция тайла относительно начала
            var tile_position : Vector2i = Vector2i( 
                x + region_position.x,
                y + region_position.y,
            )
            var tile_data_wall : TileData = layer_wall.get_cell_tile_data(tile_position) 
            if not tile_data_wall:
                layer_floor.set_cell(tile_position, 1, LIST_LAND.pick_random())

func get_array_circle(radius : int) -> Array[Vector2i]:
    var new_array : Array[Vector2i]
    var radius_range : Array = range(-radius, radius)
    for y in radius_range:
        for x in radius_range:
            if x ** 2 + y ** 2 <= (radius - 1) ** 2:
                new_array.append(Vector2i(x, y))
    return new_array
               
func map_to_local(pos : Vector2i) -> Vector2:
    return layer_floor.map_to_local(pos)

func local_to_map(pos : Vector2) -> Vector2i:
    return layer_floor.local_to_map(pos)
