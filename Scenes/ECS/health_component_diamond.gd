extends HealthComponent


func take_damage(attacker : CharacterBody2D, damage : int, _dir : Vector2, _force : int) -> void:
    parent.animation_player.play('hurt')
    health_points += damage
    
    if health_points <= 0:
        for key in parent.drop.keys():
            attacker.inventory[key] += parent.drop[key]
        parent.queue_free()
