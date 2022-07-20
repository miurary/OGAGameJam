extends Node

signal noHealth
signal healthChanged(value)
signal maxHealthChanged(value)

export var maxHealth = 1 setget setMaxHealth
var health = maxHealth setget setHealth

func _ready():
	self.health = maxHealth
	
func setMaxHealth(value):
	maxHealth = value
	self.health = min(health, maxHealth)
	emit_signal("maxHealthChanged", maxHealth)
	
func setHealth(value):
	health = value
	emit_signal("healthChanged", health)
	if health <= 0:
		emit_signal("noHealth")
