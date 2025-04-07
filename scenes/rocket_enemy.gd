extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_missile: AudioStreamPlayer2D = $EnemyMissile
@onready var hit: AudioStreamPlayer2D = $Hit

var speed = 600

func _ready() -> void:
	enemy_missile.play()
	anim.play("default")

func _physics_process(delta: float) -> void:
	global_position.y += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	hit.play()
	Global.player_health -= 3
