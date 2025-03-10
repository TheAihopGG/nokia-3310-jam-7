extends FiniteStateMachine


func _init() -> void:
	_add_state("idle")
	_add_state("move")
	_add_state("attack")
	_add_state("hurt")
	_add_state("dead")

func _ready() -> void:
	set_state(states.idle)

func _state_logic(_delta: float) -> void:
	if state == states.idle or state == states.move or state == states.attack or state == states.hurt:
		parent.get_input()
		parent.move()
		
func _get_transition() -> int:
	match state:
		states.idle:
			if parent.velocity.length() > 10:
				return states.move
				
		states.move:
			if parent.velocity.length() < 10:
				return states.idle
		
		states.attack:
			if parent.hitbox.get_child(0).disabled and not animation_player.is_playing():
				return states.idle
		
		states.hurt:
			if not animation_player.is_playing():
				return states.idle
	return -1
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	match new_state:
		states.attack:
			animation_player.play("attack")
		states.idle:
			animation_player.play("idle")
		states.move:
			animation_player.play("move")
		states.hurt:
			animation_player.play("hurt")
		states.dead:
			animation_player.play("dead")
