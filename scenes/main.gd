extends Node2D

var player = null
@onready var player_pos: Node2D = $PlayerPos
@onready var projectiles_container: Node2D = $ProjectilesContainer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	assert(player != null)
	player.global_position = player_pos.global_position
	Global.laser_shot.connect(on_player_laser_shot)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Reload"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func on_player_laser_shot(projectile_scene, location):
	var instance = projectile_scene.instantiate()
	instance.global_position = location
	projectiles_container.add_child(instance)
