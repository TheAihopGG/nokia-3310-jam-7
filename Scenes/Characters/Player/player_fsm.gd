extends FiniteStateMachine


func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("attack")

func _ready() -> void:
	set_state(states.idle)

func _get_transition() -> int:
	if round(parent.velocity.length()) > 0 and parent.hitbox.get_child(0).disabled:
		return states.move
	
	elif not parent.hitbox.get_child(0).disabled:
		return states.attack
	
	else:
		return states.idle
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.attack:
			animation_player.play("attack")

		states.idle:
			if not animation_player.current_animation == "attack":
				animation_player.play("idle")

		states.move:
			if not animation_player.current_animation == "attack":
				animation_player.play("move")
