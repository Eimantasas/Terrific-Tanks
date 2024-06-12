extends "res://Scenes/Enemies/enemy_turret.gd"

@onready var vision_ray2 = $RayCast2D


func _ready():
	$Timers/Reload.wait_time = 0.3

func _process(_delta):
	if seeing_player and Globals.playerhp > 0:
		var playerpos = theplayer.global_position
		look_at(playerpos)
		vision_ray2.look_at(playerpos)
		if vision_ray2.is_colliding():
			collider = vision_ray2.get_collider()
			if collider is player and can_fire:
				fire()

func fire():
	$AnimationPlayer.play("fire")
	$Timers/Reload.start()
	$GPUParticles2D.emitting = true
	can_fire = false
	shot_fired.emit($Bulletpos)


func _on_reload_timeout():
	can_fire = true

func _on_vision_range_body_entered(body):
	if body is player and Globals.playerhp > 0:
		seeing_player = true


func _on_vision_range_body_exited(body):
	if body is player:
		seeing_player = false

