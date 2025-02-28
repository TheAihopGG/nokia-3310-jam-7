class_name HealthComponent extends Node


@export var max_health_points : int = 3
@export var health_points     : int : 
    set = set_hp

@onready var parent : Node2D = get_parent()

signal hp_changed(new_hp)

func _ready() -> void:
    health_points = max_health_points
    
func take_damage(attacker : CharacterBody2D, damage : int, dir : Vector2, force : int) -> void:
    if attacker.is_in_group("ENEMY_GROUP") and parent.is_in_group("ENEMY_GROUP"):
        return
    
    health_points += damage
    
    if health_points > 0:
        if parent is Character:
            parent.state_machine.set_state(parent.state_machine.states.hurt)
            parent.velocity += dir * force
    else:
        if parent is Character:
            parent.state_machine.set_state(parent.state_machine.states.dead)
            parent.velocity += dir * force * 2
        else:
            parent.queue_free()
    
func set_hp(new_hp : int) -> void:
    health_points = clamp(new_hp, 0, max_health_points)
    emit_signal("hp_changed", health_points)
