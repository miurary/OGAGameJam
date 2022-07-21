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
