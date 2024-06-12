extends CharacterBody2D

signal player_seen
signal player_lost

@export var health = 50
@export var speed = 200

var speed_after_event = 200

var direction
var shotdirection
var see_player = false
var alive = true
var animatedmoving = true

var rng = RandomNumberGenerator.new()

var bullet_scene = load("res://Scenes/Projectiles/enemy_tank_bullet.tscn")


@onready var theplayer = get_tree().get_first_node_in_group("player")
@onready var navagent = $NavigationAgent2D as NavigationAgent2D

func _ready():
	shotdirection = (theplayer.global_position - self.position).normalized()
	$Explosion.visible = false
	$Sprite2D.visible = true
	$Turret.visible = true

func _process(delta):
	if see_player and speed > 0:
		move(delta)
	elif see_player == false and alive:
		$AnimationPlayer.stop()


func move(delta):
	if direction != Vector2.ZERO: #Checks if we are moving. If this statement is not here, it resets back to original rotation if we stop
		rotation = lerp_angle(rotation,velocity.angle(),0.15)
		if animatedmoving:
			$AnimationPlayer.play("going")
	
	direction = navagent.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = direction * speed * delta
	move_and_collide(velocity)


func _on_vision_range_body_entered(body):
	if  body is player and Globals.playerhp > 0:
		see_player = true
		player_seen.emit()

func getpath():
	if see_player:
		navagent.target_position = theplayer.global_position


func _on_vision_range_body_exited(_body):
	see_player = false

func hit(bulletdamage):
	$Sounds/TankHit.play()
	see_player = true
	health -= bulletdamage
	modulate.v += 1
	speed = 0
	await get_tree().create_timer(0.1).timeout
	speed = speed_after_event
	modulate.v -= 1
	if health <= 0:
		var my_random_number = rng.randf_range(0, 5)
		$Sounds/ExplosionSFX.play()
		$Turret.visible = false
		speed = 0
		alive = false
		$Explosion.visible = true
		$AnimationPlayer.play("globalanims/explode")
		$CollisionShape2D.queue_free()
		await get_tree().create_timer(1.5).timeout
		if my_random_number <= 1:
			var medkit = load("res://Scenes/Items/fix_kit.tscn")
			var fixkit = medkit.instantiate()
			get_tree().get_root().get_child(3).get_node("Items").add_child(fixkit)
			fixkit.position = self.global_position
		queue_free()


func _on_movement_timer_timeout():
	if Globals.playerhp > 0:
		getpath()


func _on_stopping_range_body_entered(body):
	if body is player and alive:
		speed = 0
		$AnimationPlayer.stop()


func _on_stopping_range_body_exited(body):
	if body is player and alive:
		speed = speed_after_event


func _on_enemy_turret_shot_fired(bulletpos):
	if alive:
		$Sounds/TankShot.play()
		shotdirection = (theplayer.position - position).normalized()
		var projectilenode = get_tree().get_first_node_in_group("projectiles")
		var thebullet = bullet_scene.instantiate() as Area2D
		projectilenode.add_child(thebullet)
		thebullet.position = bulletpos.global_position
		thebullet.rotation_degrees = rad_to_deg(shotdirection.angle())
		thebullet.direction = (theplayer.position - self.position).normalized()






func _on_hurt_box_area_entered(area):
	if area is damagingexplosion:
		hit(30)
