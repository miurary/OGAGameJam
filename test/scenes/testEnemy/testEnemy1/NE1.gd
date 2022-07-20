extends KinematicBody2D


func _on_Hurtbox_area_entered(area: Area2D) -> void:
	queue_free()
