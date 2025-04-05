extends Node2D

var speed = 300
var is_shooting = false
var direction = -1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var muzzle: Marker2D = $Muzzle
var rocket_enemy = preload("res://scenes/rocket_enemy.tscn")

func _process(delta: float) -> void:
	if !is_shooting:
		is_shooting = true
		bullet_instantiate()
		await get_tree().create_timer(5.0).timeout
		is_shooting = false
	
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
	position.x += speed * delta * direction

func bullet_instantiate():
	Global.laser_shot.emit(rocket_enemy, muzzle.global_position)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
