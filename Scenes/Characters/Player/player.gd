@icon("res://Assets/Sprites/player1.png")
class_name Player extends Character


@export var regeneration_time : float = 5

@onready var hitbox : Area2D = get_node("Hitbox")
@onready var dialog : Dialog = get_node("Dialog")
@onready var health_regeneration_timer : Timer = get_node("%HealthRegeneration")
@onready var health_component          : HealthComponent = get_node("HealthComponent")

var nearest_chest : Chest
var current_tile_position  : Vector2i
var previous_tile_position : Vector2i : set = set_current_tile_pos
var health_regeneration_enabled : bool = true

signal hp_changed(new_hp : int)
signal current_tile_pos_changed(new_current_pos : Vector2i)

func _ready() -> void:
    GlobalVars.player = self
    current_tile_position = tile_map.layer_fog.local_to_map(global_position)
    health_regeneration_timer.wait_time = regeneration_time

func _process(_delta: float) -> void:
    if move_direction.x > 0 and animated_sprite.flip_h:
        animated_sprite.flip_h = false
    elif move_direction.x < 0 and not animated_sprite.flip_h:
        animated_sprite.flip_h = true
    
    hitbox.kickback_direction = move_direction
    
    current_tile_position = tile_map.local_to_map(global_position)
    if previous_tile_position != current_tile_position:
        previous_tile_position = current_tile_position
        
func get_input():
    move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
    hitbox.position = tile_map.map_to_local(move_direction) - Vector2(4, 4)
    
    if move_direction and Input.is_action_pressed("F") and state_machine.state != state_machine.states.attack:
        state_machine.set_state(state_machine.states.attack)
        var tile_position : Vector2i = tile_map.local_to_map(hitbox.global_position)
        tile_map.breaking_tile(tile_position)
        
    if nearest_chest and Input.is_action_pressed("F"):
        if not nearest_chest.is_opened:
            if inventory['keys'] > 0:
                inventory['keys'] -= 1
                nearest_chest.open()
            else:
                dialog.say(["You need a key"])
                
func clear_fog() -> void:    
    var generating_chunk : bool = false
    for neighbor_position in tile_map.list_vectors_clear_fog:
        var neighbor_tile : Vector2i = current_tile_position + neighbor_position
        var clearing : bool = true
        
        for tile in tile_map.get_line_tiles(current_tile_position, neighbor_tile):
            var tile_data_wall : TileData = tile_map.layer_wall.get_cell_tile_data(tile) 
            if clearing:
                tile_map.clear_fog(tile)
                
            if tile_data_wall != null:
                clearing = false
                
            var tile_data_chunks : TileData = tile_map.layer_chunks.get_cell_tile_data(tile) 
            if tile_data_chunks: 
                generating_chunk = true
                
    if generating_chunk:
        tile_map.generate_chunk(global_position)
                
func set_current_tile_pos(new_current_pos : Vector2i) -> void:
    current_tile_position = new_current_pos
    clear_fog()
    emit_signal("current_tile_pos_changed", current_tile_position) 
    
func _on_health_component_hp_changed(new_hp: Variant) -> void:
    emit_signal("hp_changed", new_hp)

func _on_interaction_area_body_entered(body: Node2D) -> void:
    if body.is_in_group('Chests'):
        nearest_chest = body

    elif body.is_in_group('Items'):
        var item : Item = body
        if not item.is_picked_up:
            item.pick_up()

func _on_interaction_area_body_exited(body: Node2D) -> void:
    if body.is_in_group('Chests'):
        nearest_chest = null

func _on_health_regeneration_timeout() -> void:
    if health_regeneration_enabled and health_component.health_points < health_component.max_health_points:
        health_component.health_points += 1
