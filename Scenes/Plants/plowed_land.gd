extends Node2D


var name_object : String = "Plowed Land"

func _on_timer_dead_timeout() -> void:
    queue_free()
