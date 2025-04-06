extends Node2D

var speed = 300
var direction = -1
var is_shooting = false
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var muzzle: Marker2D = $Muzzle
var bomb = preload("res://scenes/bomb.tscn")
var can_move = false

func _ready() -> void:
	await get_tree().create_timer(Global.on_spawn_timer).timeout
	can_move = true

func _process(delta: float) -> void:
	if !can_move:
		return
	if !is_shooting:
		is_shooting = true
		bomb_instantiate()
		await get_tree().create_timer(5.0).timeout
		is_shooting = false
	
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
	position.x += speed * delta * direction

func bomb_instantiate():
	Global.laser_shot.emit(bomb, muzzle.global_position)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
