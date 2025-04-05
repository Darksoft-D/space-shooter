extends Node2D

var speed = 450
var is_shooting = false
var direction = -1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var muzzle: Marker2D = $Muzzle
var bullet = preload("res://scenes/area_2d.tscn")

func _process(delta: float) -> void:
	if !is_shooting:
		is_shooting = true
		bullet_instantiate()
		await get_tree().create_timer(1.5).timeout
		is_shooting = false
	
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
	position.x += speed * delta * direction

func bullet_instantiate():
	Global.laser_shot.emit(bullet, muzzle.global_position)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
