class_name Character extends CharacterBody2D


@onready var sprite  : Sprite2D = get_node("Sprite2D")
@onready var tilemap : Node2D = get_tree().current_scene.get_node("TileMap")
@onready var timer_delay_move : Timer = get_node("TimerDelayMove")

var move_direction : Vector2

func move() -> void:
    global_position += move_direction
    global_position = global_position.round()
        
func _physics_process(_delta: float) -> void:
    move_and_slide()
    if timer_delay_move.is_stopped():
        timer_delay_move.start()
        move()
