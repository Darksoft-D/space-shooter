extends Area2D

var speed = 350
var steer_force = 50.0 
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var target = null
var homing = false
@onready var autocannon_fire: AudioStreamPlayer2D = $AutocannonFire
@onready var autocannon_homing: AudioStreamPlayer2D = $AutocannonHoming

func _ready() -> void:
	autocannon_fire.play()
	await autocannon_fire.finished
	homing = true

func _physics_process(delta: float) -> void:
	if homing:
		homing = false
		autocannon_homing.play()
		await autocannon_homing.finished
		homing = true
	if target == null:
		global_position += position.direction_to(Vector2(global_position.x, global_position.y - 10)) * speed * delta
		return
	if global_position != target.global_position:
		global_position += position.direction_to(target.global_position) * speed * delta
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if target != null:
		return
	else:
		target = area


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
