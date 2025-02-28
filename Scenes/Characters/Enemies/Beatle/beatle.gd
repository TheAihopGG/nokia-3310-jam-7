@icon("res://Assets/Sprites/enemy4.png")
extends Enemy


@onready var hitbox: Area2D = get_node("Hitbox")


func _process(_delta: float) -> void:
    hitbox.kickback_direction = velocity.normalized()
