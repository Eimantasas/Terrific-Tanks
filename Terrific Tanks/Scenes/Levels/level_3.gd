extends Node2D

func _ready():
	$Map/WinArea/WinAreaShape.call_deferred("set", "disabled", true)
	Globals.level = 3
