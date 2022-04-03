extends KinematicBody

var path = []
var path_node = 0
var speed = 1
var threshold = 0.1
var previous_pos = Vector3(0,0,0)
var player_in_range = false
var state = "spawn"
var attackfinished = true
var lastStepSound = 9
var lastFoot=0
var bonked := false
var finishedspawning := false
var cur_target = Vector3(0,0.5,0)
var walk_animation = "Walk In Place Retarget"
onready var nav = get_parent()
onready var player = $"../../Player"
onready var anim = $AnimationPlayer
signal playerDamaged

func _ready():
	get_node("zombieAnimations/AnimationPlayer").play("Spawn")
	$Zombiecollisionshape.disabled = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("SuperSecretFunnyRun"):
		walk_animation = "FunnyRunny Retarget"

func _physics_process(delta):
	print(state)
	if !bonked and finishedspawning:
		if path.size() > 0:
			if abs(cur_target.x - global_transform.origin.x) <= 1 or abs(cur_target.z - global_transform.origin.z) <= 1 and state != "attack":
				move_to()
			if (state == "wander" or state == "chase" or state =="track") and attackfinished:
				get_node("zombieAnimations/AnimationPlayer").play(walk_animation)
				get_node("Brains").start(floor(rand_range(1,5)))
			var pv = player.global_transform.origin
			var zv = global_transform.origin
			var angle = atan2((pv.z - zv.z), (pv.x - zv.x))

			look_at(path[0], Vector3.UP)
			previous_pos = zv
	
	
		if state == "wander" or state == "track":
			if abs(cur_target.x - global_transform.origin.x) <= 1 or abs(cur_target.z - global_transform.origin.z) <= 1:
				state="wander"
				var radius = 30
				var vec = Vector3(rand_range(-radius, radius), 0.5, rand_range(-radius, radius))
				get_target_path(vec)

func move_to():
	if path_node >= path.size():
		return
	
	if global_transform.origin.distance_to(path[path_node]) < threshold:
		path_node += 1
	else:
		var direction = path[path_node] - global_transform.origin
		move_and_slide(direction.normalized() * speed, Vector3.UP)

func get_target_path(target_pos):
	cur_target = target_pos
	path = nav.get_simple_path(global_transform.origin, target_pos)

func _on_Timer_timeout():
	#spawning
	if state=="spawn":
		state = "wander"
	elif state=="chase" or state=="track":
		get_target_path(player.global_transform.origin)
	path_node = 0
	finishedspawning = true
	$Zombiecollisionshape.disabled = false

func _on_Attack_body_entered(body):
	#check if body is player
	if body.name == "Player":
		state ="attack"
		#set bool true
		player_in_range = true
		#run timer
		get_node("AttackTimer").start(.45)
		#run attack anim
		if finishedspawning and !bonked:
			get_node("zombieAnimations/AnimationPlayer").play("Attack Retarget")
			attackfinished=false

func _on_Attack_body_exited(body):
	#check if thing exited is player, set bool to false
	state="chase"
	if body.name == "Player":
		player_in_range = false

func _on_AttackTimer_timeout():
	#when timer runs out, check if bool still true
	attackfinished=true
	if player_in_range == true:
			#emit signal, deal damage
			get_node("AttackTimer").start(.45)
			if finishedspawning and !bonked:
				emit_signal("playerDamaged")
				attackfinished = false
				#run attack anim
				get_node("zombieAnimations/AnimationPlayer").play("Attack Retarget")
			
func _on_PlayerDetect_body_entered(body):
	if body.name == "Player":
		get_target_path(player.global_transform.origin)
	state = "chase"
	
func _on_PlayerDetect_body_exited(body):
	if body.name == "Player":
		var vec = player.global_transform.origin
		get_target_path(vec)
	state = "track"
	
func play_footstep():
	var randFootstep = floor(rand_range(0,5))
	var footstepPlayer = get_node("footstepPlayer1")
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

func play_footstep2():
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
	
func play_attacksound():
	var footstepPlayer = get_node("Attack2")
	footstepPlayer.stream = preload("res://Assets/Audio/attack.mp3")
	footstepPlayer.stream.set_loop(false)
	footstepPlayer.play()


func _on_Brains_timeout():
	var footstepPlayer = get_node("Brains2")
	footstepPlayer.stream = preload("res://Assets/Audio/brains.mp3")
	footstepPlayer.stream.set_loop(false)
	footstepPlayer.play()
	print("brains")

func bonk() -> void:
	if !finishedspawning:
		queue_free()
	$BonkedTimer.start(3)
	bonked = true
	get_node("zombieAnimations/AnimationPlayer").play("Idle Retarget")
	#$Zombiecollisionshape.disabled = true


func _on_CollisionArea_area_entered(area: Area):
	if area.is_in_group("bonk"):
		bonk()


func _on_BonkedTimer_timeout():
	bonked=false
	#$Zombiecollisionshape.disabled = false
