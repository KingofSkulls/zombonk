extends KinematicBody

const lookSensitivity := 50
const moveSpeed := 1.5
const gravity := 8
const jumpForce := 2

const minLookAngle := -90.0
const maxLookAngle := 90.0

onready var camera : Camera = get_node("Camera")
var bodies = []
var mouse_sens := 1.0
var camera_anglev := 0.0
var runWalktimerStarted := false
var can_jump := 0.0
export var god := false
var vel := Vector3()
var health := 100
var mouseDelta := Vector2()
var stopped := true
var sprint_time := 4.0
var base_sprint_time := 4.0
var dead :=false
var timesurvived:= 0
var zombiesbonked:= 0
var batteriescollected := 0
var base_fov := 70
var sprint_fov := 80
var lastStepSound = 9
var lastFoot := 0
var last_sprint := 0
var sprint := 0
var timealive := 0.0

var arm_attack_cd := -0.1
var despawn_hitbox_cd := -1

var hitbox = null

func _input(event) -> void:         
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
	if event is InputEventKey:
		if (event as InputEventKey).scancode == KEY_ESCAPE:
			get_tree().quit() 

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$DeathScene.hide()

func remove_weapon_hitboxes():
	for c in get_children():
		if c.name.count("bonk") > 0: 
			c.queue_free()

func _process(delta) -> void:
	var f = $Camera/Flashlight
	$"Battery Bar".value = f.get_param(f.PARAM_ENERGY) / 2.2 * 100.0
	
	if not dead:
		timealive+=delta
	reducespot(delta)
	timealive+=delta
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
		#stopped=true
		
	if last_sprint == 1 and sprint == 0:
		$FOVTween.remove_all()
		$FOVTween.interpolate_property($Camera, "fov", $Camera.fov, base_fov, 0.2)
		$FOVTween.start()
	
	last_sprint = sprint
	
	if despawn_hitbox_cd > 0:
		despawn_hitbox_cd -= 1
		if despawn_hitbox_cd <= 0:
			remove_weapon_hitboxes()
	
	if is_on_floor():
		can_jump = 0.1
	else:
		can_jump = max(0, can_jump - delta)
	
	if arm_attack_cd > 0:
		arm_attack_cd -= delta
		
		if arm_attack_cd <= 0:
			var area := Area.new()
			var collision_shape := CollisionShape.new()
			collision_shape.shape = BoxShape.new()
			
			collision_shape.shape.extents = Vector3(0.5, 0.5, 0.5)
			area.translation.z = -0.5
			
			area.name = "bonk"
			area.add_to_group("bonk")
			
			add_child(area)
			area.add_child(collision_shape)
			
			despawn_hitbox_cd = 2
			
	if Input.is_action_pressed("attack"):
		$Camera/arm/AnimationPlayer.play("BonrAction") # name was an accident too late 
														#to change it. don't @ me
		arm_attack_cd = 0.5
	
	
func _physics_process(delta) -> void:
	
	
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
		
	if abs(vel.x) > 0.2 or abs(vel.z) > 0.2:
		if !runWalktimerStarted:
			runWalktimerStarted=true
			if stopped:
				stopped = false
				if lastFoot ==0:
					play_footstep2()
				else:
					play_footstep()
			if Input.is_action_pressed("sprint") and sprint_time > 0.0:
				get_node("RunTimer").start(.5)
			else:
				get_node("WalkTimer").start(.8)
	else:
		stopped = true
		
		
func reducespot(delta) -> void:
	if not god:
		var target_node = get_node("Camera/Flashlight")
		var energy = target_node.get_param(target_node.PARAM_ENERGY)
		var angle = target_node.get_param(target_node.PARAM_SPOT_ANGLE)
		energy -= delta * 0.05
		if energy <=0:
			energy =0
		target_node.set_param(target_node.PARAM_ENERGY, energy)
		target_node.set_param(target_node.PARAM_SPOT_ANGLE, angle-delta*.15)
		
		# BATTERY BAR ??
#		$BatteryBar.value = energy / 2.2
#		print(energy)
#		print($BatteryBar.value)


func _on_batteryCollected() -> void:
	var target_node = get_node("Camera/Flashlight")
	target_node.set_param(target_node.PARAM_ENERGY, 2.2)
	target_node.set_param(target_node.PARAM_SPOT_ANGLE, 19)
	batteriescollected+=1
	
	

func play_footstep() -> void:
	var randFootstep = floor(rand_range(0,5))
	var footstepPlayer = get_node("footstepPlayer")
	while randFootstep == lastStepSound:
		randFootstep = floor(rand_range(0,5))
	match str(randFootstep):
		"0":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep1.mp3")
		"1":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep2.mp3")
		"2":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep3.mp3")
		"3":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep4.mp3")
		"4":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep5.mp3")
	footstepPlayer.stream.set_loop(false)
	footstepPlayer.play()
	lastStepSound = randFootstep
	lastFoot =0

func play_footstep2() -> void:
	var randFootstep = floor(rand_range(0,5))
	var footstepPlayer = get_node("footstepPlayer2")
	while randFootstep == lastStepSound:
		randFootstep = floor(rand_range(0,5))
	match str(randFootstep):
		"0":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep1.mp3")
		"1":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep2.mp3")
		"2":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep3.mp3")
		"3":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep4.mp3")
		"4":
			footstepPlayer.stream = preload("res://Assets//Audio//footstep5.mp3")
	footstepPlayer.stream.set_loop(false)
	footstepPlayer.play()
	lastStepSound = randFootstep
	lastFoot =1
	


func _on_RunTimer_timeout() -> void:
	runWalktimerStarted=false
	if vel.x !=0:
		if Input.is_action_pressed("sprint"):
			if lastFoot ==0:
				play_footstep2()
			else:
				play_footstep()
		else:
			pass

func _on_WalkTimer_timeout() -> void:
	runWalktimerStarted=false
	if vel.x !=0:
		if Input.is_action_pressed("sprint"):
			pass
		else:
			if lastFoot ==0:
				play_footstep2()
			else:
				play_footstep()


func _on_Zombie_playerDamaged() -> void:
	health -= 33
	print(health)
	$DamageVignette.self_modulate.a = (100 - health) / 100
	if health <= 0:
		death()
		

func death() -> void:
	print("You Died")
	get_tree().paused = true
	$DeathScene.show()
	dead=true
	
func zombbonk():
	zombiesbonked+=1

