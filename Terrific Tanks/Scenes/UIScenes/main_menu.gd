extends Control

func _on_quit_button_up():
	get_tree().quit()


func _on_play_button_up():
	SceneTransitionRect.change_scene("res://Scenes/UIScenes/level_menu.tscn")



func _on_back_button_up():
	$MarginContainer/HelpMenu.visible = false


func _on_how_to_button_up():
	$MarginContainer/HelpMenu.visible = true


func _on_ok_button_up():
	$MarginContainer/Disclaimer.visible = false


func _on_link_button_button_up():
	OS.shell_open("https://www.waterflame.com/")
