extends CharacterBody2D

class_name player

signal player_hit(playerhp: int)
signal player_died


		## Camera Shake Variables ##
# The starting range of possible offsets using random values
@export var RANDOM_SHAKE_STRENGTH: float = 8.0
# Multiplier for lerping the shake strength to zero
@export var SHAKE_DECAY_RATE: float = 5.0

@onready var camera = $Camera2D
@onready var rand = RandomNumberGenerator.new()
var shake_strength: float = 0.0

var previous_player_hp = Globals.playerhp

		## Other Variables ##
var alive = true

var bullet_scene = load("res://Scenes/Projectiles/tank_bullet.tscn")

var player_direction

func _ready():
	Globals.playerspeed = 250
	Globals.playerhp = 100
	$Explosion.visible = false
	$Sprite2D.visible = true
	$Turret.visible = true
	rand.randomize()

func _process(delta):
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, SHAKE_DECAY_RATE * delta)
	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	camera.offset = get_random_offset()
	
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = Globals.playerspeed * direction * delta
	if direction != Vector2.ZERO and alive: #Checks if we are moving. If this statement is not here, it resets back to original rotation if we stop
		rotation = lerp_angle(rotation,velocity.angle(),0.15) #smoothly rotates the vehicle in the direction we are moving towards
		$AnimationPlayer.play("going")
	elif alive == false:
		pass
	else:
		$AnimationPlayer.stop()
		
	#look_at(global_transform.origin + velocity) ## This rotates it,  but not smoothly
	move_and_collide(velocity)
	
	if previous_player_hp != Globals.playerhp:
		player_hit.emit(Globals.playerhp)
		previous_player_hp = Globals.playerhp
	

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)


func _on_turret_fired():
	Sfx.tank_shot()
	shake_strength = RANDOM_SHAKE_STRENGTH
	var bulletposnode = get_tree().get_first_node_in_group("bulletpos")
	player_direction = (get_global_mouse_position() - self.position).normalized()
	var projectilenode = get_tree().get_first_node_in_group("projectiles")
	var bulletpos = bulletposnode.global_position
	var thebullet = bullet_scene.instantiate() as Area2D
	projectilenode.add_child(thebullet)
	thebullet.position = bulletpos
	thebullet.rotation_degrees = rad_to_deg(player_direction.angle())
	thebullet.direction = (get_global_mouse_position() - position).normalized()


func hit(bullet_damage):
	if alive:
		Sfx.tank_hit()
		shake_strength = RANDOM_SHAKE_STRENGTH - 2
		Globals.playerhp -= bullet_damage / 1.5
		modulate.v += 1
		await get_tree().create_timer(0.1).timeout
		modulate.v -= 1
		if Globals.playerhp <= 0:
			on_destroy()

func on_destroy():
	Sfx.death_sound()
	player_died.emit()
	shake_strength = RANDOM_SHAKE_STRENGTH + 25
	alive = false
	$Explosion.visible = true
	Globals.playerspeed = 0
	$AnimationPlayer.play("explode")
	await get_tree().create_timer(1.5).timeout




func _on_hurt_box_area_entered(area):
	if area is damagingexplosion:
		Globals.playerhp -= 30
		player_hit.emit(Globals.playerhp)
		shake_strength = RANDOM_SHAKE_STRENGTH + 18
