class_name Diamond extends StaticBody2D


@export var drop = {
	'diamonds': 10
}

@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	animated_sprite.frame = randi_range(0, 3)

func _on_health_component_hp_changed(new_hp: Variant) -> void:
	if new_hp == 0:
		animation_player.play("destructed")
