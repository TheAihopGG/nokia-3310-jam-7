@icon("res://Assets/test_player.png")
class_name Character extends CharacterBody2D


@export var acceleration      : int = 5 # ускорение
@export var max_speed         : int = 40 

@onready var sprite  : Sprite2D = get_node("Sprite2D")
@onready var tilemap : Node2D = get_tree().current_scene.get_node("TileMap")

const FRICTION : float = 0.15

var move_direction : Vector2
var movement_enabled : bool = true

func _physics_process(_delta: float) -> void:
    move_and_slide()
    move()
    reverse_sprite()
    get_input()
    velocity = lerp(velocity, Vector2.ZERO, FRICTION) 

func get_input():
    pass
    
func move() -> void:
    velocity += move_direction * acceleration
    velocity = velocity.limit_length(max_speed)

func reverse_sprite() -> void:
    if move_direction.x > 0 and sprite.flip_h:
        sprite.flip_h = false
    elif move_direction.x < 0 and not sprite.flip_h:
        sprite.flip_h = true
