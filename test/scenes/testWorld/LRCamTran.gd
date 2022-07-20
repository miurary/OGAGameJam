extends Area2D

signal updateCamera(value)

var isHole = false
var isBoundary = true

func _on_LRCamTran_area_entered(area):
	print("entered")
	if area.get_parent().name == "Player":
		var player = area.get_parent()
		print(player.position)
		emit_signal("updateCamera", player.velocity.x)
		print("signal emitted")
