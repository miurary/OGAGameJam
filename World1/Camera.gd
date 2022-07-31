#https://www.youtube.com/watch?v=CqU6w164AbU&ab_channel=GDQuest

extends Camera2D
const x = 768 #magic number
const y = 481 #magic number

func _on_LRCamTran_updateCamera(value):
	print("value:", value)
	if value > 0:
		global_position.x += x
	else:
		global_position.x -= x


func _on_UDCamTran_updateCamera(value):
	if value > 0:
		global_position.y += y
	else:
		global_position.y -= y


func _on_BossCamTran_updateToBossCamera(value):
	limit_left = -256
	limit_right = 768
	limit_top = -864
	limit_bottom = -320
	zoom.x *= 1.5
	zoom.y *= 1.5
