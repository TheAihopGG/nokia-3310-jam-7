extends CanvasLayer


@onready var health_bar : AnimatedSprite2D = get_node("HealthBar")
@onready var diamonds_counter : Label = get_node("DiamondsCounter")
@onready var player : CharacterBody2D = get_node("../Player")

func _on_player_hp_changed(new_hp: int) -> void:
	health_bar.frame = new_hp

func _process(_delta: float) -> void:
	if player != null:
		diamonds_counter.text = str(player.inventory['diamonds'])
