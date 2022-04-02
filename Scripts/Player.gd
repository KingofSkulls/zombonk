extends KinematicBody

const lookSensitivity := 50
const moveSpeed := 1.5
const gravity := 8
const jumpForce := 2

const minLookAngle := -90.0
const maxLookAngle := 90.0

onready var camera : Camera = get_node("Camera")

var mouse_sens := 1.0
var camera_anglev := 0.0

var can_jump := 0.0

var vel := Vector3()

var mouseDelta := Vector2()

var sprint_time := 2.0
var base_sprint_time := 2.0

var base_fov := 70
var sprint_fov := 80

var last_sprint := 0
var sprint := 0

func _input(event):         
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	if event is InputEventKey:
		if (event as InputEventKey).scancode == KEY_ESCAPE:
			get_tree().quit() 

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	reducespot(delta)
	camera.rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
	
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta

	mouseDelta = Vector2()
	
	if Input.is_action_pressed("sprint"):
		sprint_time = max(0, sprint_time - delta)
		if sprint_time > 0:
			sprint = 1
		else:
			sprint = 0
	else:
		sprint_time = min(base_sprint_time, sprint_time + delta)
		sprint = 0

	if last_sprint == 0 and sprint == 1:
		$FOVTween.remove_all()
		$FOVTween.interpolate_property($Camera, "fov", $Camera.fov, sprint_fov, 0.2)
		$FOVTween.start()
		
	if last_sprint == 1 and sprint == 0:
		$FOVTween.remove_all()
		$FOVTween.interpolate_property($Camera, "fov", $Camera.fov, base_fov, 0.2)
		$FOVTween.start()
	
	last_sprint = sprint
	
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
	
	var forward := global_transform.basis.z
	var right := global_transform.basis.x
	
	var relativeDir = (forward * input.y + right * input.x)
	
	var speedMod := 1.0
	
	if sprint_time > 0.0 and Input.is_action_pressed("sprint"):
		speedMod = 1.5
	
	vel.x = relativeDir.x * moveSpeed * speedMod
	vel.z = relativeDir.z * moveSpeed * speedMod
	
	# apply gravity
	vel.y -= gravity * delta
	
	# move the player
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_action_pressed("jump") and can_jump != 0:
		vel.y = jumpForce
		can_jump = 0
		
func reducespot(delta):
	var target_node = get_node("Camera/Flashlight")
	#target_node.PARAM_ENERGY -=delta
	var energy = target_node.get_param(target_node.PARAM_ENERGY)
	energy -=delta*0.05
	if energy <=0:
		energy =0
	target_node.set_param(target_node.PARAM_ENERGY, energy)
