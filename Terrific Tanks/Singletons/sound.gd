extends Node

func menu_music():
	$MenuMusic.play()

func menu_music_stop():
	$MenuMusic.stop()

func battle_music():
	var rng = RandomNumberGenerator.new()
	var my_random_number = rng.randf_range(-10.0, 10.0)
	if my_random_number >= 0:
		$BattleMusic.play()
	else:
		$BattleMusic2.play()

func battle_music_stop():
		$BattleMusic.stop()
		$BattleMusic2.stop()

func death_sound():
	$ExplosionSound.play()

func tank_shot():
	$TankShot.play()

func tank_hit():
	$HitSFX.play()
