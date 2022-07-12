extends KinematicBody2D

enum {
	MOVE,
	ATTACK,
	JUMP,
	FALL
}

const ACCELERATION = 500
const MAX_SPEED = 200
const FRICTION = 1000

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var state = MOVE
var velocity = Vector2.ZERO

func _ready():
	animationTree.active = true
	print("Player ready function finished")

func _physics_process(delta):
	match state:
		MOVE:
			moveState(delta)
		ATTACK:
			attackState()
		JUMP:
			jumpState()
		FALL:
			fallState()
	
	
func moveState(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Jump/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		
	if Input.is_action_just_pressed("jump"):
		state = JUMP
	
func attackState():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func attackAnimationFinished():
	state = MOVE

func jumpState():
	animationState.travel("Jump")
	move()
	
func jumpAnimationFinished():
	state = MOVE
	velocity = velocity * .75
	
func fallState():
	velocity = Vector2.ZERO
	animationState.travel("Falling")
	pass
	
func fallAnimationFinished():
	pass
	
func move():
	velocity = move_and_slide(velocity)

func _on_Hole_area_entered(area):
	print("hole area entered by...", area.name)
	
	if state == JUMP:
		print("jumping!")
	else:
		print("Falling...")
		state = FALL
		
		
