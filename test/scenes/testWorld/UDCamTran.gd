extends Area2D

signal updateCamera(value)

var isHole = false
var isBoundary = true

func _on_UDCamTran_area_entered(area):
	print("entered")
	if area.get_parent().name == "Player":
		var player = area.get_parent()
		print(player.position)
		emit_signal("updateCamera", player.velocity.y)
		print("signal emitted")
