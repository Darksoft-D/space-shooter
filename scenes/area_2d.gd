extends Area2D

var speed = 400
@onready var enemy_bullet: AudioStreamPlayer2D = $EnemyBullet
@onready var hit: AudioStreamPlayer2D = $Hit

func _ready() -> void:
	enemy_bullet.play()

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	hit.play()
	Global.player_health -= 1
