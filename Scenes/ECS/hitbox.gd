class_name Hitbox extends Area2D 


@export var damage : int = -1
@export var delay_attack : float = 0.5
@export var kickback_force : int = 150
var kickback_direction : Vector2 = Vector2.ZERO

@onready var collision : CollisionShape2D = get_child(0)
@onready var timer     : Timer = Timer.new()
@onready var parent    : CharacterBody2D = owner

var body_inside : bool = false

func _init():
	var __ = connect("body_entered", Callable(self, "_on_body_entered"))
	__ = connect("body_exited", Callable(self, "_on_body_exited"))
	
func _ready():
	add_child(timer)
	timer.autostart = true
	# Ошибка если нету коллизии
	assert(collision != null)
	
func _on_body_entered(body):
	body_inside = true
	timer.start(delay_attack)
	# Пока зона урона внутри тела, будет наноситься урон с частотой в timer
	while body_inside:
		_collide(body)
		await timer.timeout

func _on_body_exited(_body):
	body_inside = false
	timer.stop()

func _collide(body) -> void:
	if body == null or not body.has_node("HealthComponent"):
		pass
	else:
		if not body.get_node("HealthComponent").is_taking_damage:
			return
		body.get_node("HealthComponent").take_damage(parent, damage, kickback_direction, kickback_force)
