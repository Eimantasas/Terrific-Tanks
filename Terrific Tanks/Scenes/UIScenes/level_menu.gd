extends Control


func _on_back_button_up():
	SceneTransitionRect.change_scene("res://Scenes/UIScenes/main_menu.tscn")


func _on_level_1_button_up():
	Sfx.menu_music_stop()
	SceneTransitionRect.change_scene("res://Scenes/Levels/level_1.tscn")
	

func _on_level_2_button_up():
	Sfx.menu_music_stop()
	SceneTransitionRect.change_scene("res://Scenes/Levels/level_2.tscn")


func _on_level_3_button_up():
	Sfx.menu_music_stop()
	SceneTransitionRect.change_scene("res://Scenes/Levels/level_3.tscn")


func _on_level_4_button_up():
	Sfx.menu_music_stop()
	SceneTransitionRect.change_scene("res://Scenes/Levels/level_4.tscn")


func _on_level_5_button_up():
	Sfx.menu_music_stop()
	SceneTransitionRect.change_scene("res://Scenes/Levels/level_5.tscn")

func _on_level_6_button_up():
	Sfx.menu_music_stop()
	SceneTransitionRect.change_scene("res://Scenes/Levels/level_6.tscn")


