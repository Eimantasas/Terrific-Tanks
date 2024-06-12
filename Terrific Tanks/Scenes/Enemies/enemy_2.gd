extends "res://Scenes/Enemies/enemy_1.gd"

func _ready():
	bullet_scene = load("res://Scenes/Projectiles/apc_bullet.tscn")
	animatedmoving = false
	shotdirection = (theplayer.global_position - self.position).normalized()
	$Explosion.visible = false
	$Sprite2D.visible = true
	$Turret.visible = true
	health = 30
	speed = 300
	speed_after_event = 300

func hit(bulletdamage):
	$Node/TankHit.play()
	see_player = true
	health -= bulletdamage
	modulate.v += 1
	speed = 0
	await get_tree().create_timer(0.1).timeout
	speed = speed_after_event
	modulate.v -= 1
	if health <= 0:
		$Node/ExplosionSFX.play()
		$Turret.visible = false
		speed = 0
		alive = false
		$Explosion.visible = true
		$AnimationPlayer.play("globalanims/explode")
		$CollisionShape2D.queue_free()
		await get_tree().create_timer(1.5).timeout
		queue_free()


func _on_turret_shot_fired(bulletpos):
	if alive:
		$Node/ApcShot.play()
		shotdirection = (theplayer.position - position).normalized()
		var projectilenode = get_tree().get_first_node_in_group("projectiles")
		var thebullet = bullet_scene.instantiate() as Area2D
		projectilenode.add_child(thebullet)
		thebullet.position = bulletpos.global_position
		thebullet.rotation_degrees = rad_to_deg(shotdirection.angle())
		thebullet.direction = (theplayer.position - self.position).normalized()
