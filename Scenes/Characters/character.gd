class_name Character extends CharacterBody2D


@export var accerelation : int = 5 # ускорение
@export var max_speed    : int = 40 
@export var max_health : int = 3
@export var health : int = max_health

@onready var sprite  : Sprite2D = get_node("Sprite2D")
@onready var tilemap : Node2D = get_tree().current_scene.get_node("TileMap")

const FRICTION : float = 0.15

var move_direction : Vector2
var movement_enabled : bool = true

signal health_reduced(new_health : int)
signal died()

func _ready() -> void:
    if health > max_health:
        health = max_health

func _physics_process(_delta: float) -> void:
    move_and_slide()
    move()
    velocity = lerp(velocity, Vector2.ZERO, FRICTION) 


func move() -> void:
    velocity += move_direction * accerelation
    velocity = velocity.limit_length(max_speed)


func take_damage(count : int) -> void:
    health += count
    if health > max_health:
        health = max_health
    
    elif health < 0:
        health = 0
    
    if health == 0:
        died.emit()
    
    health_reduced.emit(health)
