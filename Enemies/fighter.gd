extends Node2D

var health = 2
var speed = 300
var is_shooting = false
var direction = -1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var muzzle: Marker2D = $Muzzle
@onready var muzzle_2: Marker2D = $Muzzle2
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hit: AudioStreamPlayer2D = $Hit
@onready var explosion: AudioStreamPlayer2D = $Explosion

var bullet = preload("res://scenes/area_2d.tscn")
var can_move = false

func _ready() -> void:
	await get_tree().create_timer(Global.on_spawn_timer).timeout
	can_move = true
	
func _process(delta: float) -> void:
	if health <= 0 and can_move:
		can_move = false
		anim.play("destruction")
		await anim.animation_finished
		queue_free()
	if !can_move:
		return
	if !is_shooting:
		is_shooting = true
		bullet_instantiate()
		await get_tree().create_timer(3.0).timeout
		is_shooting = false
	
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
	position.x += speed * delta * direction

func bullet_instantiate():
	anim.play("shoot")
	await get_tree().create_timer(0.5).timeout
	Global.laser_shot.emit(bullet, muzzle.global_position)
	await get_tree().create_timer(1.0).timeout
	Global.laser_shot.emit(bullet, muzzle_2.global_position)
	await anim.animation_finished
	anim.play("default")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("rocket"):
		health -= 1
		area.queue_free()
	if area.is_in_group("bundleofenergy"):
		health -= 5
		area.queue_free()
	if area.is_in_group("laser"):
		health -= 3
	if area.is_in_group("auto_cannon_bullet"):
		health -= 1
		area.queue_free()
	if health > 0:
		anim.play("hit")
		await anim.animation_finished
		anim.play("default")
		hit.play()
	if health <= 0:
		explosion.play()
		Global.score += 200
