class_name Player extends Character


var inventory = {
	'diamonds': 0
}
var nearest_diamond : Diamond
var destructing_enabled : bool = true


func _ready() -> void:
	GlobalVars.player = $"."


func _process(_delta: float) -> void:
	determine_direction()
	destructing()


func determine_direction() -> void:
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_direction.x > 0 and sprite.flip_h:
		sprite.flip_h = false
	elif move_direction.x < 0 and not sprite.flip_h:
		sprite.flip_h = true


func destructing() -> void:
	if destructing_enabled:
		if nearest_diamond and Input.is_action_just_pressed('destruct'):
			if not nearest_diamond.is_destructed:
				nearest_diamond._start_destruction()

		elif nearest_diamond and Input.is_action_just_released('destruct'):
			if not nearest_diamond.is_destructed:
				nearest_diamond._stop_destruction()


func _on_destruction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('Diamonds'):
		nearest_diamond = body


func _on_destruction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group('Diamonds'):
		nearest_diamond = null
