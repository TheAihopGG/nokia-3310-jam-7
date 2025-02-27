@icon("res://Assets/Sprites/player1.png")
class_name Player extends Character


@onready var hitbox : Area2D = get_node("RotateWeapon/Hitbox")
@onready var rotate_weapon : Node2D = get_node("RotateWeapon")

var inventory : Dictionary = {
	'diamonds': 0,
	'keys': 0
}
var nearest_chest : Chest

signal hp_changed(new_hp : int)

func _ready() -> void:
	GlobalVars.player = self

func get_input():
	move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	rotate_weapon.look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("F") or Input.is_action_pressed("left_button_mouse"):
		hitbox.get_child(0).disabled = false
	else:
		hitbox.get_child(0).disabled = true
	
	if nearest_chest and Input.is_action_just_pressed("F"):
		if not nearest_chest.is_opened:
			if inventory['keys'] > 0:
				inventory['keys'] -= 1
				nearest_chest._open()
	
func _on_health_component_hp_changed(new_hp: Variant) -> void:
	emit_signal("hp_changed", new_hp)

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('Chests'):
		nearest_chest = body

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group('Chests'):
		nearest_chest = null

func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if body.is_in_group('Items'):
		var item : Item = body
		if not item.is_picked_up:
			item._pick_up()
