extends Node2D

var health = 5
var speed = 300
var is_shooting = false
var direction = -1
var can_move = false
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var muzzle: Marker2D = $Muzzle
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var rocket_enemy = preload("res://scenes/rocket_enemy.tscn")

func _ready() -> void:
	await get_tree().create_timer(Global.on_spawn_timer).timeout
	can_move = true

func _process(delta: float) -> void:
	if health <= 0:
		can_move = false
		anim.play("destruction")
		await anim.animation_finished
		queue_free()
	if !can_move:
		return
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
	anim.play("shoot")
	await anim.animation_finished
	anim.play("default")
	Global.laser_shot.emit(rocket_enemy, muzzle.global_position)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("rocket"):
		health -= 1
	if area.is_in_group("bundleofenergy"):
		health -= 5
	if area.is_in_group("laser"):
		health -= 3
	if area.is_in_group("auto_cannon_bullet"):
		health -= 1
		area.queue_free()
	if health > 0:
		anim.play("hit")
		await anim.animation_finished
		anim.play("default")
