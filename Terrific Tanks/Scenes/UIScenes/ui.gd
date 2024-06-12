extends CanvasLayer

var game_done = false
var total_enemies

func _ready():
	Sfx.battle_music()
	count_enemies()
	get_parent().get_node("Map/WinArea").visible = false
	$Interface/MarginContainer/HBoxContainer/EndPanel.visible = false
	$Interface/MarginContainer/HBoxContainer/EndPanel.modulate.a = 0
	
	if get_parent().name == "Level1":
		$Interface/MarginContainer/InfoPanel.visible = true
		$Interface/MarginContainer/InfoPanel/Label.text = "Green APCs: They shoot\n and move fast, but\n lack durability. Only\n a problem if there are\n many of them."
		$Interface/MarginContainer/InfoPanel/APCTexture.visible = true
		$Interface/MarginContainer/InfoPanel/TankTexture.visible = false
		$Interface/MarginContainer/InfoPanel/BombTexture.visible = false
		await get_tree().create_timer(0.7).timeout
		get_tree().paused = true
	
	elif get_parent().name == "Level3":
		$Interface/MarginContainer/InfoPanel.visible = true
		$Interface/MarginContainer/InfoPanel/Label.text = "Yellow Tanks: They shoot\n slower, do more damage\n and are more durable.\n They also have a\n chance to drop a fixkit."
		$Interface/MarginContainer/InfoPanel/APCTexture.visible = false
		$Interface/MarginContainer/InfoPanel/TankTexture.visible = true
		$Interface/MarginContainer/InfoPanel/BombTexture.visible = false
		await get_tree().create_timer(0.7).timeout
		get_tree().paused = true
	
	elif get_parent().name == "Level6":
		$Interface/MarginContainer/InfoPanel.visible = true
		$Interface/MarginContainer/InfoPanel/Label.text = "Red Bombers: They don't\n shoot, they come after\n you and try to explode\n next to you. They also\n do damage to enemies."
		$Interface/MarginContainer/InfoPanel/APCTexture.visible = false
		$Interface/MarginContainer/InfoPanel/TankTexture.visible = false
		$Interface/MarginContainer/InfoPanel/BombTexture.visible = true
		await get_tree().create_timer(0.7).timeout
		get_tree().paused = true
	else:
		$Interface/MarginContainer/InfoPanel.visible = false
		get_tree().paused = false


func _process(_delta):
	count_enemies()
	if game_done:
		$Interface/MarginContainer/HBoxContainer/EndPanel.visible = true
		$Interface/MarginContainer/HBoxContainer/EndPanel.modulate.a += 0.02

func _on_player_tank_player_hit(playerhp):
	$Interface/MarginContainer/PlayerHpBar.value = playerhp


func _on_player_tank_player_died():
	game_done = true
	$Interface/MarginContainer/HBoxContainer/EndPanel/Back.disabled = true
	$Interface/MarginContainer/HBoxContainer/EndPanel/Restart.disabled = true
	$Interface/MarginContainer/HBoxContainer/EndPanel/Label.text = "Wow. Next time \n try not to explode"
	await get_tree().create_timer(2).timeout
	$Interface/MarginContainer/HBoxContainer/EndPanel/Back.disabled = false
	$Interface/MarginContainer/HBoxContainer/EndPanel/Restart.disabled = false
	get_tree().paused = true


func _on_back_button_up():
	Sfx.menu_music()
	Sfx.battle_music_stop()
	SceneTransitionRect.change_scene("res://Scenes/UIScenes/level_menu.tscn")
	get_tree().paused = false


func _on_restart_button_up():
	Sfx.battle_music_stop()
	get_tree().paused = false
	get_tree().reload_current_scene()


func count_enemies():
	total_enemies = $"../Enemies".get_child_count()
	$Interface/MarginContainer/EnemyCount.text = str(total_enemies, " Enemies")
	if total_enemies == 0:
		get_tree().get_first_node_in_group("WinAreaShape").call_deferred("set", "disabled", false)
		get_parent().get_node("Map/WinArea").visible = true


func _on_win_area_body_entered(body):
	if body is player:
		game_done = true
		$Interface/MarginContainer/HBoxContainer/EndPanel/Label.text = "Enemies \n exterminated. \n You win!"
		get_tree().paused = true


func _on_ok_button_up():
	get_tree().paused = false
	$Interface/MarginContainer/InfoPanel.visible = false
