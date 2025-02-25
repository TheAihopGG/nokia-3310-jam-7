class_name HealthBar extends AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	frame = GlobalVars.player.health
