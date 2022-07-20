extends Area2D

signal invincibilityStarted
signal invincibilityEnded

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

var invincible = false setget setInvincible

func setInvincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibilityStarted")
	else:
		emit_signal("invincibilityEnded")
		
func startInvincibility(duration):
	self.invincible = true
	timer.start(duration)
	
func _on_Timer_timeout():
	self.invincible = false


func _on_Hurtbox_invincibilityStarted():
	collisionShape.set_deferred("disabled", true)


func _on_Hurtbox_invincibilityEnded():
	collisionShape.disabled = false
