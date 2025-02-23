extends Node2D


@onready var selected    : Sprite2D = get_node("%Select")
@onready var tile_map    : Node2D = get_node("TileMap")
@onready var description : Label = get_node("%Description")

const PLOWED_LAND : PackedScene = preload("res://Scenes/Plants/plowed_land.tscn")

func _input(event: InputEvent) -> void:
    var selected_tile : Vector2 = tile_map.map_to_local(tile_map.local_to_map(get_global_mouse_position()))
    selected.global_position = selected_tile
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            _add_plowed_land(selected_tile)
        if event.button_index == MOUSE_BUTTON_RIGHT:
            var objects_tile : Array[Node2D] = get_nodes_on_tile(selected_tile)
            if objects_tile:
                description.text = str(objects_tile[0].name_object)

func _add_plowed_land(pos : Vector2) -> void:
    var new_plowed_land : Node2D = PLOWED_LAND.instantiate()
    add_child(new_plowed_land)
    new_plowed_land.global_position = pos

func get_nodes_on_tile(pos : Vector2) -> Array[Node2D]:
    var objects_on_tile : Array[Node2D]
    for object in get_tree().get_nodes_in_group("Objects"):
        if object.global_position == pos:
            objects_on_tile.append(object)
    return objects_on_tile
        
        
        
        
