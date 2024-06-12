extends Area2D

signal shot_fired

var seeing_player = false
var can_fire = true
var can_reload = false
var collider

@onready var vision_ray = $RayCast2D

@onready var theplayer = get_tree().get_first_node_in_group("player")


func _process(_delta):
	if seeing_player and Globals.playerhp > 0:
		var playerpos = theplayer.global_position
		look_at(playerpos)
		vision_ray.look_at(playerpos)
		if vision_ray.is_colliding():
			collider = vision_ray.get_collider()
			if collider is player and can_fire:
				fire()


func _on_enemy_1_player_lost():
	seeing_player = false


func _on_enemy_1_player_seen():
	seeing_player = true

func fire():
	$AnimationPlayer.play("fire")
	$GPUParticles2D.emitting = true
	can_fire = false
	shot_fired.emit($Bulletpos)
	$Timers/Reload.start()


func _on_reload_timeout():
	can_fire = true
