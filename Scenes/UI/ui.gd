extends CanvasLayer


@onready var health_bar : AnimatedSprite2D = get_node("HealthBar")
@onready var diamonds_counter : Label = get_node("DiamondsCounter")

func _on_player_hp_changed(new_hp: int) -> void:
	health_bar.frame = new_hp

func _process(_delta: float) -> void:
	if GlobalVars.player != null:
		diamonds_counter.text = str(GlobalVars.player.inventory['diamonds'])
