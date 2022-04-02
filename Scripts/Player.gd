extends KinematicBody

const lookSensitivity = 10
const moveSpeed = 1.2
const gravity = 8
const jumpForce = 2

const minLookAngle = -90.0
const maxLookAngle = 90.0

onready var camera : Camera = get_node("Camera")

var mouse_sens = 0.3
var camera_anglev = 0

var can_jump = 0

var vel = Vector3()

var mouseDelta = Vector2()

func _input(event):         
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta

	mouseDelta = Vector2()
	
	if is_on_floor():
		can_jump = 0.1
	else:
		can_jump = max(0, can_jump - delta)
	
func _physics_process(delta):
	# reset the x and z velocity
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	if Input.is_action_pressed("move_forward"):
		input.y -= 1
	if Input.is_action_pressed("move_backward"):
		input.y += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_right"):
		input.x += 1

	input = input.normalized()
	
	var forward = global_transform.basis.z
	var right = global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)

	vel.x = relativeDir.x * moveSpeed
	vel.z = relativeDir.z * moveSpeed
	
	# apply gravity
	vel.y -= gravity * delta
	
	# move the player
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_action_pressed("jump") and can_jump != 0:
		vel.y = jumpForce
		can_jump = 0
