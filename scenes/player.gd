extends CharacterBody2D

const SPEED = 25000.0
var rocket_scene = preload("res://scenes/rocket.tscn")
var lazer_scene = preload("res://scenes/lazer.tscn")
var energy_projectile = preload("res://scenes/bundleofenergy.tscn")
var auto_cannon_bullet = preload("res://scenes/auto_cannon_bullet.tscn")
var shoot_cd = false
var selected_weapon = 1
@onready var marker_2d: Marker2D = $Marker2D

@export var lazer_points: Array[Marker2D] = []

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("1st weapon"):
		selected_weapon = 1
	if Input.is_action_just_pressed("2nd weapon"):
		selected_weapon = 2
	if Input.is_action_just_pressed("3rd weapon"):
		selected_weapon = 3
	if Input.is_action_just_pressed("4th weapon"):
		selected_weapon = 4
	if Input.is_action_pressed("shoot") and !shoot_cd:
		shoot_cd = true
		match selected_weapon:
			1:
				shoot()
				await get_tree().create_timer(0.5).timeout
			2:
				shoot_lazer()
				await get_tree().create_timer(10.0).timeout
			3:
				shoot_3()
				await get_tree().create_timer(2.0).timeout
			4:
				shoot_homing_bullet()
				await get_tree().create_timer(1.0).timeout
		shoot_cd = false

func _physics_process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up" ,"move_down"))
	velocity = direction * SPEED * delta
	move_and_slide()

func shoot():
	Global.laser_shot.emit(rocket_scene, marker_2d.global_position)

func shoot_lazer():
	for marker in lazer_points:
		var instance = lazer_scene.instantiate()
		instance.position = marker.position
		add_child(instance)
func shoot_3():
	Global.laser_shot.emit(energy_projectile, marker_2d.global_position)
	
func shoot_homing_bullet():
	Global.laser_shot.emit(auto_cannon_bullet, marker_2d.global_position)
