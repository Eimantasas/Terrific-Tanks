extends Area2D

class_name MedKit

@export var heal_amount = 25

func _on_body_entered(body):
	if body is player:
		Globals.playerhp += heal_amount
		if Globals.playerhp > 100:
			Globals.playerhp = 100
		queue_free()
