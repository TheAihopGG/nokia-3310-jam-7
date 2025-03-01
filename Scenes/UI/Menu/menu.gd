class_name Menu extends Node2D


@onready var sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")

func _ready() -> void:
    sprite.play('default')

func _process(_delta: float) -> void:
    if Input.is_anything_pressed():
        get_tree().change_scene_to_file("res://Scenes/game.tscn")
