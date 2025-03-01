extends CanvasLayer


@onready var health_bar : AnimatedSprite2D = get_node("HealthBar")
@onready var diamonds_counter : Label = get_node("DiamondsCounter")
@onready var button_again : Button = get_node("ButtonAgain")

func _on_player_hp_changed(new_hp: int) -> void:
    health_bar.frame = new_hp
    if new_hp == 0:
        button_again.show()

func _process(_delta: float) -> void:
    if GlobalVars.player != null:
        diamonds_counter.text = str(GlobalVars.player.inventory['diamonds'])

func _on_button_again_pressed() -> void:
    get_tree().change_scene_to_file("res://Scenes/game.tscn")
