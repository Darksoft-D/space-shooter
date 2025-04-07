extends Node2D

var player = null
var can_spawn = true
var can_spawn_ammo = true
var instance = null
var last_ammo = null
var row = null
@onready var player_pos: Node2D = $PlayerPos
@onready var projectiles_container: Node2D = $ProjectilesContainer
@onready var label: Label = $CanvasLayer/PanelContainer2/HBoxContainer/Label
@onready var label_2: Label = $CanvasLayer/PanelContainer2/HBoxContainer/Label2
@onready var label_3: Label = $CanvasLayer/PanelContainer2/HBoxContainer/Label3
@onready var label_score: Label = $CanvasLayer/PanelContainer3/HBoxContainer/LabelScore
@onready var health: Label = $CanvasLayer/PanelContainer3/HBoxContainer/Health
@onready var panel_container: PanelContainer = $CanvasLayer/PanelContainer

@export var enemy_scenes: Array[PackedScene] = []
@export var enemy_spawnpoints: Array[Node2D] = []
@export var enemy_rows: Array[Node2D] = []
@export var ammos: Array[PackedScene] = []
var enemy_row1: Array = []
var enemy_row2: Array = []
var enemy_row3: Array = []
var game_over_scene = preload("res://game_over.tscn")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	assert(player != null)
	player.global_position = player_pos.global_position
	Global.laser_shot.connect(on_player_laser_shot)
	await get_tree().create_timer(5.0).timeout
	panel_container.hide()

func _physics_process(delta: float) -> void:
	if instance == null:
		return
	if instance.global_position.y < row.global_position.y:
		instance.global_position.y += delta * 130

func _process(delta: float) -> void:
	label.text = str(Global.laser_ammo)
	label_2.text = str(Global.big_space_gun_ammo)
	label_3.text = str(Global.auto_cannon_ammo)
	label_score.text = " " + str(Global.score) + " "
	health.text = str(Global.player_health) + " "
	if Global.player_health <= 0:
		health.text = "0 "
		var game_over = game_over_scene.instantiate()
		game_over.global_position = global_position
		add_child(game_over)
	if can_spawn_ammo:
		can_spawn_ammo = false
		ammo_spawn()
		await get_tree().create_timer(10.0).timeout
		can_spawn_ammo = true
	if can_spawn:
		can_spawn = false
		await get_tree().create_timer(5.0).timeout
		enemy_spawn()
		can_spawn = true
		
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func on_player_laser_shot(projectile_scene, location):
	var instance = projectile_scene.instantiate()
	instance.global_position = location
	projectiles_container.add_child(instance)
	

func enemy_spawn():
	instance = enemy_scenes.pick_random().instantiate()
	instance.global_position = enemy_spawnpoints.pick_random().global_position
	add_child(instance)
	row = enemy_rows.pick_random()
	if row == enemy_rows[0]:
		Global.on_spawn_timer = 1.0
		enemy_row1.append(instance)
	elif row == enemy_rows[1]:
		Global.on_spawn_timer = 2.0
		enemy_row2.append(instance)
	elif row == enemy_rows[2]:
		Global.on_spawn_timer = 3.0
		enemy_row3.append(instance)

func ammo_spawn():
	var ammo = ammos.pick_random().instantiate()
	var pos = Vector2(randi_range(30, 1120), randi_range(270, 600))
	ammo.global_position = pos
	add_child(ammo)
	last_ammo = ammo
