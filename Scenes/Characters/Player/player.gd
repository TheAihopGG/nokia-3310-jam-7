class_name Player extends Character

func _ready() -> void:
	GlobalVars.player = $"."

func _process(_delta: float) -> void:
	move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if move_direction.x > 0 and sprite.flip_h:
		sprite.flip_h = false
	elif move_direction.x < 0 and not sprite.flip_h:
		sprite.flip_h = true
