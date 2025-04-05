extends CharacterBody2D

const SPEED = 500.0
var rocket_scene = preload("res://scenes/rocket.tscn")
var shoot_cd = false
@onready var marker_2d: Marker2D = $Marker2D

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and !shoot_cd:
		shoot_cd = true
		shoot()
		await get_tree().create_timer(0.5).timeout
		shoot_cd = false

func _physics_process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up" ,"move_down"))
	velocity = direction * SPEED
	move_and_slide()

func shoot():
	Global.laser_shot.emit(rocket_scene, marker_2d.global_position)
