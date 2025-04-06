extends Area2D

var speed = 350
var steer_force = 50.0 
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null

func _physics_process(delta: float) -> void:
	if target == null:
		return
	if global_position != target.global_position:
		look_at(-target.global_position)
		global_position += position.direction_to(target.global_position) * speed * delta
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if target != null:
		return
	else:
		target = area
