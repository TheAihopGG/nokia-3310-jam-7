class_name Diamond extends StaticBody2D


@export var destruction_time : float = 1
@export var drop = {
	'diamonds': 10
}


@onready var destruction_timer : Timer = get_node('%DestructionTimer')
@onready var animated_sprite : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var collision_shape : CollisionShape2D = get_node("CollisionShape2D")
@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")


var is_collapsing : bool = false
var is_destructed : bool = false


func _start_destruction() -> void:
	is_collapsing = true
	destruction_timer.start(destruction_time)
	animation_player.play('destruction')


func _stop_destruction() -> void:
	is_collapsing = false
	destruction_timer.stop()
	animation_player.stop()


func _on_destruction_timer_timeout() -> void:
	is_collapsing = false
	is_destructed = true
	animated_sprite.visible = false
	collision_shape.disabled = true
	for key in drop.keys():
		GlobalVars.player.inventory[key] = drop[key]
