extends Sprite2D



func _on_stopping_range_body_entered(_body):
	$AnimationPlayer.play("spinning")
