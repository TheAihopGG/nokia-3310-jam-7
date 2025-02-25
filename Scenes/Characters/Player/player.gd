class_name Player extends Character

var inventory = {
	'diamonds': 0
}
var nearest_diamond : Diamond
var can_destruct : bool = false

func _ready() -> void:
	GlobalVars.player = $"."

func _process(_delta: float) -> void:
	# print(inventory)
	move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if move_direction.x > 0 and sprite.flip_h:
		sprite.flip_h = false
	elif move_direction.x < 0 and not sprite.flip_h:
		sprite.flip_h = true
	
	if can_destruct and Input.is_action_just_pressed('destruct'):
		if not nearest_diamond.is_destructed:
			nearest_diamond._start_destruction()
	
	elif can_destruct and Input.is_action_just_released('destruct'):
		if not nearest_diamond.is_destructed:
			nearest_diamond._stop_destruction()

func _on_destruction_area_body_entered(body: Node2D) -> void:
	print(body)
	if body.is_in_group('Diamonds'):
		nearest_diamond = body
		can_destruct = true

func _on_destruction_area_body_exited(body: Node2D) -> void:
	print(body)
	if body.is_in_group('Diamonds'):
		nearest_diamond = null
		can_destruct = false
