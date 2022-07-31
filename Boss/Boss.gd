extends KinematicBody2D

signal death(value)

enum {
	IDLE,
	SUMMON,
	JUMP
}

const ACCELERATION = 300
const MAXSPEED = 100
const FRICTION = 200
const WANDERTARGETRANGE = 4
const JUMPDELAY = .3

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var summonTimer = $SummonTimer

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE
var summonableEnemies = 1

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			idleState(delta)
		SUMMON:
			summonState(delta)
		JUMP:
			chaseState(delta)
			
	if softCollision.isColliding():
		velocity += softCollision.getPushVector() * delta * 400
	velocity = move_and_slide(velocity)
			
func idleState(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
func summonState(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	summonTimer.start(5.0)
	
func chaseState(delta):
	var player = playerDetectionZone.player
	if player != null:
		accelerateTowardsPoint(player.global_position, delta)
	else:
		state = IDLE
		
func accelerateTowardsPoint(position, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAXSPEED, ACCELERATION * delta)
	#handle sprite here


func _on_Hurtbox_area_entered(area):
	print("slime damaged")
	stats.health -= area.damage
	knockback = area.knockbackVector * 120
	hurtbox.startInvincibility(0.4)


func _on_Stats_noHealth():
	queue_free()
	emit_signal("death", name)
	#handle death effects


func _on_SummonTimer_timeout(delta): #delta might not work here - needs testing
	var player = playerDetectionZone.player
	if player != null:
		summonSlime(player.global_position, delta)
		#state = JUMP
	
func summonSlime(position, delta):
	var direction = global_position.direction_to(position)
