extends Node2D


@onready var layer_floor : TileMapLayer = get_node("LayerFloor")
@onready var layer_wall  : TileMapLayer = get_node("LayerWall")
@onready var layer_fog   : TileMapLayer = get_node("LayerFog")

const LIST_LAND : Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]

var list_vectors : Array[Vector2i] = get_array_circle(4)

var endurance_tiles : Dictionary


    #generate_chunk()
    
func generate_chunk() -> void:
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
            layer_floor.set_cell(tile_position, 1, LIST_LAND.pick_random())
            #var tile_data_wall : TileData = layer_wall.get_cell_tile_data(tile_position) 

func breaking_tile(tile_pos : Vector2i) -> void:
    var tile_date = layer_wall.get_cell_tile_data(tile_pos) # получает данные о тайле
    if tile_date:
        if tile_pos not in endurance_tiles:
            endurance_tiles[tile_pos] = 2
        endurance_tiles[tile_pos] -= 1
        if endurance_tiles[tile_pos] <= 0:
            layer_wall.set_cells_terrain_connect([tile_pos], 0, -1, false)
            endurance_tiles.erase(tile_pos)
    
func get_array_circle(radius : int) -> Array[Vector2i]:
    var new_array : Array[Vector2i]
    var radius_range : Array = range(-radius, radius)
    for y in radius_range:
        for x in radius_range:
            if x ** 2 + y ** 2 <= (radius - 1) ** 2 and x ** 2 + y ** 2 >= (radius - 2) ** 2:
                new_array.append(Vector2i(x, y))
    return new_array
    
func get_line_tiles(start: Vector2, end: Vector2) -> Array[Vector2]:
    var tiles : Array[Vector2] = []
    
    var dx : int = abs(end.x - start.x)
    var dy : int = abs(end.y - start.y)
    
    var sx : int = 1 if start.x < end.x else -1
    var sy : int = 1 if start.y < end.y else -1
    
    var err : int = dx - dy
    
    while true:
        tiles.append(Vector2(start.x, start.y))  # Добавляем текущую точку в массив
        
        if start.x == end.x && start.y == end.y:  # Если достигли конечной точки, выходим
            break
        
        var e2 = 2 * err
        if e2 > -dy:
            err -= dy
            start.x += sx
        if e2 < dx:
            err += dx
            start.y += sy
    
    return tiles
              
func map_to_local(pos : Vector2i) -> Vector2:
    return layer_floor.map_to_local(pos)

func local_to_map(pos : Vector2) -> Vector2i:
    return layer_floor.local_to_map(pos)
