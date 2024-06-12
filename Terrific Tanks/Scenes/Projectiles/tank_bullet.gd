extends Area2D

class_name bullet

@export var bullet_damage = 20
@export var speed: int = 1200
var direction: Vector2 = Vector2.RIGHT

var bodyhit: bool = false

func _ready():
	$Timers/SelfDestructionTimer.start()

func _process(delta):
	position += direction * speed * delta


func _on_body_entered(body):
	if body.has_method("hit") and bodyhit == false: #or <if "hit" in body:>, also checks if body was hit already, so it doesnt hit twice accidentally
		body.hit(bullet_damage)
		bodyhit = true
	on_destroy()
	remove_child($CollisionShape2D)


func _on_self_destruction_timer_timeout():
	on_destroy()


func on_destroy():
	speed = 0
	$GPUParticles2D.emitting = true
	$Sprite2D.visible = false
	await get_tree().create_timer(0.6).timeout
	queue_free()
