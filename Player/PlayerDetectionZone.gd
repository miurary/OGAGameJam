extends Area2D

var player = null
var fasterPlayer = null

func canSeePlayer():
	return player != null
	
func canStillSeePlayer():
	return fasterPlayer != null
	
func _on_body_entered(body):
	player = body

func _on_body_exited(body):
	player = null

func _on_PlayerDetectZone2_body_entered(body):
	fasterPlayer = body

func _on_PlayerDetectZone2_body_exited(body):
	fasterPlayer = null
