extends Area2D

var speed = 400

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position.y += -speed * delta
