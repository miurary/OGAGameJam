extends Area2D

signal updateToBossCamera(value)

var isHole = false
var isBoundary = true

func _on_BossCamTran_area_entered(area):
	print("entered")
	if area.get_parent().name == "Player":
		var player = area.get_parent()
		print(player.position)
		emit_signal("updateToBossCamera", player.velocity.y)
		print("signal emitted")
		collision_layer = 7
