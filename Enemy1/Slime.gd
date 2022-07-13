extends KinematicBody2D

signal death(value)

enum {
	IDLE,
	WANDER,
	CHASE
}

const ACCELERATION = 300
const MAXSPEED = 100
const FRICTION = 200
const WANDERTARGETRANGE = 4

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = CHASE

func _ready():
	state = pickRandomState([IDLE, WANDER])

func pickRandomState(stateList):
	stateList.shuffle()
	return stateList.pop_front()

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			idleState(delta)
		WANDER:
			wanderState(delta)
		CHASE:
			chaseState(delta)
			
	if softCollision.isColliding():
		velocity += softCollision.getPushVector() * delta * 400
	velocity = move_and_slide(velocity)
			
func idleState(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	seekPlayer()
	
	if wanderController.getTimeLeft() == 0:
		updateWander()
	
func seekPlayer():
	if playerDetectionZone.canSeePlayer():
		state = CHASE
	
func wanderState(delta):
	seekPlayer()
	if wanderController.getTimeLeft() == 0:
		updateWander()
		
	accelerateTowardsPoint(wanderController.targetPosition, delta)
	
	if global_position.distance_to(wanderController.targetPosition) <= WANDERTARGETRANGE:
		updateWander()
	
func updateWander():
	state = pickRandomState([IDLE, WANDER])
	wanderController.startTimer(rand_range(1, 3))

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
