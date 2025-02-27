class_name Diamond extends StaticBody2D


@export var drop = {
    'diamonds': 10
}

@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")
