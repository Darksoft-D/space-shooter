extends Area2D

@onready var picking: AudioStreamPlayer2D = $Picking
var can_pick = true
func _on_body_entered(body: Node2D) -> void:
	if !can_pick:
		return
	can_pick = false
	picking.play()
	Global.auto_cannon_ammo += 1
	await picking.finished
	queue_free()
