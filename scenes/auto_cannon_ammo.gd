extends Area2D

func _on_body_entered(body: Node2D) -> void:
	Global.auto_cannon_ammo += 1
	queue_free()
