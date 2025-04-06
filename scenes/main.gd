extends Node2D

var player = null
var can_spawn = true
var instance = null
var row = null
@onready var player_pos: Node2D = $PlayerPos
@onready var projectiles_container: Node2D = $ProjectilesContainer

@export var enemy_scenes: Array[PackedScene] = []
@export var enemy_spawnpoints: Array[Node2D] = []
@export var enemy_rows: Array[Node2D] = []
var enemy_row1: Array = []
var enemy_row2: Array = []
var enemy_row3: Array = []

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	assert(player != null)
	player.global_position = player_pos.global_position
	Global.laser_shot.connect(on_player_laser_shot)

func _physics_process(delta: float) -> void:
	if instance == null:
		return
	if instance.global_position.y < row.global_position.y:
		instance.global_position.y += delta * 130

func _process(delta: float) -> void:
	if can_spawn:
		can_spawn = false
		await get_tree().create_timer(5.0).timeout
		enemy_spawn()
		can_spawn = true
		if enemy_row1.size() == 5 and enemy_row2.size() == 5 and enemy_row3.size() == 5:
			can_spawn = false
		
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
	if enemy_row1.size() == 5:
		enemy_rows.erase($Row)
	if enemy_row2.size() == 5:
		enemy_rows.erase($Row2)
	if enemy_row3.size() == 5:
		enemy_rows.erase($Row3)
	
