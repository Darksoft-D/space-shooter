extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Global.big_space_gun_ammo += 1
	queue_free()
