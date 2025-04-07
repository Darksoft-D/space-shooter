extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_main: AudioStreamPlayer2D = $ShootMain

var speed = 600

func _ready() -> void:
	shoot_main.play()
	anim.play("default")

func _physics_process(delta: float) -> void:
	global_position.y += -speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.queue_free()
