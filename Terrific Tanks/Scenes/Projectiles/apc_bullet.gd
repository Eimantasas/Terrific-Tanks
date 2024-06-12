extends "res://Scenes/Projectiles/tank_bullet.gd"

func _ready():
	$Timers/SelfDestructionTimer.start()
	bullet_damage = 3
	speed = 1400
