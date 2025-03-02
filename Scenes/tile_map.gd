extends Node2D


@export var caves_noise : FastNoiseLite

@onready var layer_floor  : TileMapLayer = get_node("LayerFloor")
@onready var layer_wall   : TileMapLayer = get_node("LayerWall")
@onready var layer_fog    : TileMapLayer = get_node("LayerFog")
@onready var layer_path   : TileMapLayer = get_node("LayerPath")
@onready var layer_chunks : TileMapLayer = get_node("LayerChunks")

const DIAMOND_SCENE  : PackedScene = preload("res://Scenes/Objects/Diamond/diamond.tscn")
const BEATLE_SCENE   : PackedScene = preload("res://Scenes/Characters/Enemies/Beatle/beatle.tscn")
const CHEST_SCENE    : PackedScene = preload("res://Scenes/Objects/Chest/chest.tscn")
const KEY_SCENE      : PackedScene = preload("res://Scenes/Objects/Item/Items/key.tscn")
const BREAKING_SCENE : PackedScene = preload("res://Scenes/animated_breaking.tscn")

const LIST_LAND : Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1)]

var list_vectors_clear_fog : Array[Vector2i] = get_array_circle(3)
const LIST_VECTORS : Array[Vector2i] = [
	-Vector2i.ONE, Vector2i.UP, Vector2i(1, -1),
	Vector2i.LEFT, Vector2i.ZERO, Vector2i.RIGHT,
	Vector2i(-1, 1), Vector2i.DOWN, Vector2i.ONE
]

var endurance_tiles : Dictionary

func _ready() -> void:
	caves_noise.seed = randi()
	
func generate_chunk(pos : Vector2) -> void:
	var center_tile : Vector2i = local_to_map(pos)
	 # полные размеры карты и координаты начального тайла
	var region_size : Vector2i = Vector2i(9, 9)
	var list_new_tiles : Array[Vector2i] 
	for x in region_size.x:
		for y in region_size.y:
			# позиция тайла относительно начала
			var tile_position  : Vector2i = Vector2i(x, y) + center_tile - region_size / 2
			
			var tile_data_path  : TileData = layer_path.get_cell_tile_data(tile_position) 
			var tile_data_floor : TileData = layer_floor.get_cell_tile_data(tile_position) 
			
			#границы чанков
			if x == 0 or y == 0 or\
			x == region_size.x - 1 or y == region_size.y - 1:
				if not tile_data_path:
					if x == 0:
						layer_fog.set_cell(tile_position + Vector2i.LEFT, 2, Vector2i.ZERO)
					if y == 0:
						layer_fog.set_cell(tile_position + Vector2i.UP, 2, Vector2i.ZERO)
					if x == region_size.x - 1:
						layer_fog.set_cell(tile_position + Vector2i.RIGHT, 2, Vector2i.ZERO)
					if y == region_size.y - 1:
						layer_fog.set_cell(tile_position + Vector2i.DOWN, 2, Vector2i.ZERO)
					
				if not path_is_nearby(tile_position):
					layer_chunks.set_cell(tile_position, 3, Vector2i.ZERO)
			else:
				layer_chunks.erase_cell(tile_position)
			
			#туман появляется там, где не было игрока
			if not tile_data_path:
				layer_fog.set_cell(tile_position, 2, Vector2i.ZERO)
				
			var tile_data_fog : TileData = layer_fog.get_cell_tile_data(tile_position)
			
			var caves_altitude : float = caves_noise.get_noise_2d(tile_position.x, tile_position.y)
			
			#новые тайлы стен, где есть туман
			if tile_data_fog:
				if caves_altitude < 0.2:
					if not randi_range(0, 39):
						spawn_object(DIAMOND_SCENE, tile_position)
					else:
						list_new_tiles.append(tile_position)
				else:
					if not randi_range(0, 199):
						spawn_object(KEY_SCENE, tile_position)
					elif not randi_range(0, 149):
						spawn_object(CHEST_SCENE, tile_position)
					elif not randi_range(0, 29):
						spawn_object(DIAMOND_SCENE, tile_position)
					elif not randi_range(0, 19):
						spawn_object(BEATLE_SCENE, tile_position)
				
			#пол появляется там, где нету пола
			if not tile_data_floor:
				layer_floor.set_cell(tile_position, 1, LIST_LAND.pick_random())
	   
	layer_wall.set_cells_terrain_connect(list_new_tiles, 0, 0)

func path_is_nearby(tile_pos : Vector2i) -> bool:
	for neighbor in LIST_VECTORS:
		var tile_data_path : TileData = layer_path.get_cell_tile_data(neighbor + tile_pos) 
		if tile_data_path:
			return true
	return false

func spawn_object(object_scene : PackedScene, tile_pos : Vector2i) -> Node2D:
	var new_object : Node2D = object_scene.instantiate()
	get_tree().current_scene.add_child(new_object)
	
	new_object.global_position = map_to_local(tile_pos)
	return new_object

func clear_fog(tile_position : Vector2i) -> void:
	layer_fog.erase_cell(tile_position) 
	layer_path.set_cell(tile_position, 3, Vector2i.ZERO)
	
func breaking_tile(tile_pos : Vector2i) -> void:
	var tile_date = layer_wall.get_cell_tile_data(tile_pos) # получает данные о тайле
	if tile_date:
		if tile_pos not in endurance_tiles:
			endurance_tiles[tile_pos] = [6, spawn_object(BREAKING_SCENE, tile_pos)]
			
		endurance_tiles[tile_pos][0] -= 1 * GlobalVars.level_pickaxe
		endurance_tiles[tile_pos][1].frame += 1 * GlobalVars.level_pickaxe
		
		if endurance_tiles[tile_pos][0] <= 0:
			layer_wall.set_cells_terrain_connect([tile_pos], 0, -1, false)
			endurance_tiles[tile_pos][1].queue_free()
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

func local_to_map(pos : Vector2) -> Vector2:
	return layer_floor.local_to_map(pos)
