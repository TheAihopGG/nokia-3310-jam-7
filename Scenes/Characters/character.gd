class_name Character extends CharacterBody2D


@export var max_health : int = 3
@export var speed : float = 5

@onready var health : int = max_health
@onready var sprite  : Sprite2D = get_node("Sprite2D")
@onready var tilemap : Node2D = get_tree().current_scene.get_node("TileMap")

var move_direction : Vector2
var movement_enabled : bool = true


signal health_reduced(new_health : int)
signal died()


func _physics_process(_delta: float) -> void:
	movement()
	move_and_slide()


func movement() -> void:
	if movement_enabled:
		velocity = move_direction.normalized() * speed


func reduce_health(count : int) -> void:
	health += count
	if health > max_health:
		health = max_health
	
	elif health < 0:
		health = 0
	
	if health == 0:
		died.emit()
	
	health_reduced.emit(health)
