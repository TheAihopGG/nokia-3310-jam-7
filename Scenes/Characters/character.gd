@icon("res://Assets/test_player.png")
class_name Character extends CharacterBody2D


@export var acceleration : int = 5 # ускорение
@export var max_speed    : int = 40 

@onready var state_machine : Node = get_node("FiniteStateMachine")
@onready var animated_sprite  : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var tile_map : Node2D = get_tree().current_scene.get_node("TileMap")

const FRICTION : float = 0.15

var move_direction : Vector2

var inventory : Dictionary = {
	'diamonds': 0,
	'keys': 0
}

func _physics_process(_delta: float) -> void:
	move_and_slide()
	velocity = lerp(velocity, Vector2.ZERO, FRICTION) 
	
func move() -> void:
	velocity += move_direction * acceleration
	velocity = velocity.limit_length(max_speed)
