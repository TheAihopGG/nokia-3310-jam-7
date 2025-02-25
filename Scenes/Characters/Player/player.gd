class_name Player extends Character


@onready var hitbox : Area2D = get_node("RotateWeapon/Hitbox")
@onready var rotate_weapon : Node2D = get_node("RotateWeapon")

var inventory : Dictionary = {
    'diamonds': 0
}

signal hp_changed(new_hp : int)

func _ready() -> void:
    GlobalVars.player = self
    
func _process(_delta: float) -> void:
    get_input()

func get_input():
    move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
    rotate_weapon.look_at(get_global_mouse_position())
    
    if Input.is_action_pressed("F") or Input.is_action_pressed("left_button_mouse"):
        hitbox.get_child(0).disabled = false
    else:
        hitbox.get_child(0).disabled = true
    
func _on_health_component_hp_changed(new_hp: Variant) -> void:
    emit_signal("hp_changed", new_hp)
