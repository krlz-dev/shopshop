extends CharacterBody2D

@export var ACCELERATION = 300
@export var MAX_SPEED = 400
@export var FRICTION = 300
@export var ROTATION_SPEED = 1.5

enum {
	MOVE,
	COLLECT_LEFT,
	COLLECT_RIGHT
}

var state = MOVE
var rotation_dir = 0

func _ready():
	velocity = Vector2.ZERO

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		COLLECT_LEFT:
			collect_state_left(delta)
		COLLECT_RIGHT:
			collect_state_right(delta)

func move_state(delta):
	rotation_dir = 0
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if Input.is_action_pressed("ui_left"):
		rotation_dir -= 1

	if Input.is_action_pressed("ui_right"):
		rotation_dir += 1
		
	if Input.is_action_pressed("ui_up"):
		velocity = velocity.move_toward(input_vector.rotated(rotation) * MAX_SPEED, ACCELERATION * delta)

	if Input.is_action_pressed("ui_down"):
		velocity = velocity.move_toward(input_vector.rotated(rotation) * MAX_SPEED, ACCELERATION * delta)
		
	if input_vector.y == 0:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

		
	move(delta)

func move(delta):
	rotation += rotation_dir * ROTATION_SPEED * delta
	move_and_slide()
	
func collect_state_left(delta):
	rotation += rotation_dir * ROTATION_SPEED * delta
	move_and_slide()
	
func collect_state_right(delta):
	rotation += rotation_dir * ROTATION_SPEED * delta
	move_and_slide()

func collectAnimationFinish():
	state = MOVE
