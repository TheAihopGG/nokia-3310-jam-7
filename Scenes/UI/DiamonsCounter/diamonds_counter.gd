class_name DiamondsCounter extends Label


func _process(_delta: float) -> void:
	text = str(GlobalVars.player.inventory['diamonds'])
