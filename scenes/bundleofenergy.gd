extends Area2D

var speed = 400
@onready var space_gun: AudioStreamPlayer2D = $SpaceGun
@onready var spacegun_explosion: AudioStreamPlayer2D = $SpacegunExplosion

func _ready() -> void:
	space_gun.play()
	await get_tree().create_timer(3.0).timeout
	spacegun_explosion.play()
	await spacegun_explosion.finished
	queue_free()

func _physics_process(delta: float) -> void:
	global_position.y += -speed * delta
