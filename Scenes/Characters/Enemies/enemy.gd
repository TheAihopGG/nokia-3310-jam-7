class_name Enemy extends Character


func chase() -> void:
    if is_instance_valid(GlobalVars.player):
        move_direction = global_position.direction_to(GlobalVars.player.global_position) * acceleration
    else:
        move_direction = Vector2.ZERO
