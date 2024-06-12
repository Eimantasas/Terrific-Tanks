extends "res://Scenes/Enemies/enemy_1.gd"


func _ready():
	$StoppingRange/CollisionShape2D.call_deferred("set", "disabled", false)
	$BombHitbox/CollisionShape2D.call_deferred("set", "disabled", true)
	$CollisionShape2D.call_deferred("set", "disabled", false)
	speed = 275
	animatedmoving = true
	$Explosion.visible = false
	$Sprite2D.visible = true
	$BombHead.visible = true
	speed_after_event = 175
	health = 30

func hit(bulletdamage):
	$Sounds/TankHit.play()
	see_player = true
	health -= bulletdamage
	modulate.v += 1
	speed = 0
	await get_tree().create_timer(0.1).timeout
	speed = 260
	modulate.v -= 1
	if health <= 0:
		$Sounds/ExplosionSFX.play()
		$CollisionShape2D.call_deferred("set", "disabled", true)
		speed = 0
		alive = false
		$Explosion.visible = true
		$AnimationPlayer.play("explode")
		$BombHitbox/CollisionShape2D.call_deferred("set", "disabled", false)
		await get_tree().create_timer(0.2).timeout
		$BombHitbox/CollisionShape2D.call_deferred("set", "disabled", true)
		$CollisionShape2D.queue_free()
		await get_tree().create_timer(1.5).timeout
		queue_free()

func _on_stopping_range_body_entered(body):
	if body is player and alive:
		speed = 0
		$StoppingRange/CollisionShape2D.call_deferred("set", "disabled", true)
		$AnimationPlayer.play("spinningexplode")
		await get_tree().create_timer(1.8).timeout
		$AnimationPlayer.play("explode")
		$Explosion.visible = true
		$Sounds/ExplosionSFX.play()
		$CollisionShape2D.call_deferred("set", "disabled", true)
		speed = 0
		$BombHitbox/CollisionShape2D.call_deferred("set", "disabled", false)
		await get_tree().create_timer(0.2).timeout
		$BombHitbox/CollisionShape2D.call_deferred("set", "disabled", true)
		await get_tree().create_timer(1.8).timeout
		queue_free()
