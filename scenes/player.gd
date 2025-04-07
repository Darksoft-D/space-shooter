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
@onready var sprite_base: AnimatedSprite2D = $SpriteBase
@onready var weapons: AnimatedSprite2D = $Weapons
@onready var explosion: AudioStreamPlayer2D = $Explosion


func _process(delta: float) -> void:
	if Global.player_health > 15:
		sprite_base.play("default")
	elif Global.player_health <= 15 and Global.player_health > 10:
		sprite_base.play("slightly_damaged")
	elif Global.player_health <= 10 and Global.player_health > 5:
		sprite_base.play("damaged")
	elif Global.player_health <= 5 and Global.player_health > 0:
		sprite_base.play("very_damaged")
	elif Global.player_health <= 0:
		explosion.play()
		queue_free()
	if Global.game_over == true:
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("1st weapon"):
		weapons.play("default")
		selected_weapon = 1
	if Input.is_action_just_pressed("2nd weapon"):
		weapons.play("laser")
		selected_weapon = 2
	if Input.is_action_just_pressed("3rd weapon"):
		weapons.play("big_space_gun")
		selected_weapon = 3
	if Input.is_action_just_pressed("4th weapon"):
		weapons.play("auto_cannon_default")
		selected_weapon = 4
	if Input.is_action_pressed("shoot") and !shoot_cd:
		shoot_cd = true
		match selected_weapon:
			1:
				shoot()
				await get_tree().create_timer(1.0).timeout
			2:
				if Global.laser_ammo > 0:
					weapons.play("laser_shoot")
					await weapons.animation_finished
					shoot_lazer()
					weapons.play("laser_reload")
					await weapons.animation_finished
					weapons.play("laser")
					Global.laser_ammo -= 1
			3:
				if Global.big_space_gun_ammo > 0:
					weapons.play("big_space_gun_shoot")
					await weapons.animation_finished
					shoot_3()
					weapons.play("big_space_gun_reload")
					await weapons.animation_finished
					weapons.play("big_space_gun")
					Global.big_space_gun_ammo -= 1
			4:
				if Global.auto_cannon_ammo > 0:
					weapons.play("auto_cannon_shoot")
					await weapons.animation_finished
					shoot_homing_bullet()
					await get_tree().create_timer(1.0).timeout
					weapons.play("auto_cannon_default")
					Global.auto_cannon_ammo -= 1
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
