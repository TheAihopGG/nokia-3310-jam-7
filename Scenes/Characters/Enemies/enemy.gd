extends Character


@onready var navigation = get_node("NavigationAgent2D")
@onready var pathTimer: Timer = get_node("PathTimer")
@onready var player = get_tree().current_scene.get_node("Player")


func get_input():
	chase()
	
func chase() -> void:
	if not navigation.is_target_reached():
		var vector_to_next_point : Vector2 = navigation.get_next_path_position() - global_position 
		move_direction = vector_to_next_point

func _on_path_timer_timeout():
	if is_instance_valid(player):
		set_movement_target(player.position)
	else:
		pathTimer.stop()
		move_direction = Vector2.ZERO

func set_movement_target(target_point : Vector2) -> void:
	navigation.target_position = target_point
