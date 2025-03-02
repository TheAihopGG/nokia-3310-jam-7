extends CanvasLayer


@onready var health_bar : AnimatedSprite2D = get_node("HealthBar")
@onready var diamonds_counter : Label = get_node("DiamondsCounter")
@onready var label_again   : Label = get_node("%LabelAgain")
@onready var label_upgrate : Label = get_node("%LabelUpgrate")

func _on_player_hp_changed(new_hp: int) -> void:
	health_bar.frame = new_hp
	if new_hp == 0:
		label_again.show()

func _process(_delta: float) -> void:
	if is_instance_valid(GlobalVars.player):
		diamonds_counter.text = str(GlobalVars.player.inventory['diamonds'])
	if is_instance_valid(GlobalVars.player) and\
	GlobalVars.player.inventory['diamonds'] >= GlobalVars.levels_pickaxe[GlobalVars.level_pickaxe - 1]:
		%LabelNeedDiamonds.show()
		%LabelUpgrate.show()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		GlobalVars.level_pickaxe = 1
		get_tree().change_scene_to_file("res://Scenes/game.tscn")
		
	if event.is_action_pressed("2") and is_instance_valid(GlobalVars.player) and\
	GlobalVars.player.inventory['diamonds'] >= GlobalVars.levels_pickaxe[GlobalVars.level_pickaxe - 1]:
		GlobalVars.level_pickaxe += 1
		%LabelNeedDiamonds.text = "You need " + str(GlobalVars.levels_pickaxe[GlobalVars.level_pickaxe - 1]) + " diamonds"
		%LabelUpgrate.hide()
		%LabelNeedDiamonds.show()
		%Timer.start()

func _on_timer_timeout() -> void:
	%LabelNeedDiamonds.hide()
