extends Area2D

signal fired

var can_shoot: bool = true
var _smoothed_mouse_pos: Vector2
var bullet_scene = load("res://Scenes/Projectiles/tank_bullet.tscn")
var player_direction


func _ready():
	pass

func _process(_delta):
	player_direction = (get_global_mouse_position() - self.position).normalized()
	_smoothed_mouse_pos = lerp(_smoothed_mouse_pos, get_global_mouse_position(), 0.15)
	if Globals.playerhp > 0:
		look_at(_smoothed_mouse_pos)
	if Input.is_action_just_pressed("primary_action") and can_shoot and Globals.playerhp > 0:
		fire()


func fire():
	$Timers/ReloadTimer.start()
	$AnimationPlayer.play("fire")
	$GPUParticles2D.emitting = true
	can_shoot = false
	fired.emit()
	


func _on_reload_timer_timeout():
	can_shoot = true
