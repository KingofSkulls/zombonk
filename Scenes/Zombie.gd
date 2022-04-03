extends KinematicBody

var path = []
var path_node = 0
var speed = 1
var threshold = 0.1
var previous_pos = Vector3(0,0,0)
var player_in_range = false
var state = "spawn"
var cur_target = Vector3(0,0.5,0)
onready var nav = get_parent()
onready var player = $"../../Player"
onready var anim = $AnimationPlayer
signal playerDamaged

func _ready():
	pass

func _physics_process(delta):
	if path.size() > 0:
		move_to()
		if state == "wander" or state == "chase" or state =="track":
			get_node("zombie_test_animations/AnimationPlayer").play("Walk In Place Retarget")
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
	print(state)

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
	get_target_path(player.global_transform.origin)
	path_node = 0

func _on_Attack_body_entered(body):
	#check if body is player
	state ="attack"
	if body.name == "Player":
		#set bool true
		player_in_range = true
		#run timer
		get_node("AttackTimer").start(.5)
		#run attack anim
		get_node("zombie_test_animations/AnimationPlayer").play("Attack Retarget")

func _on_Attack_body_exited(body):
	#check if thing exited is player, set bool to false
	state="chase"
	if body.name == "Player":
		player_in_range = false

func _on_AttackTimer_timeout():
	#when timer runs out, check if bool still true
	if player_in_range == true:
			#emit signal, deal damage
			emit_signal("playerDamaged")
			get_node("AttackTimer").start(.5)
			#run attack anim
			get_node("zombie_test_animations/AnimationPlayer").play("Attack Retarget")
func _on_PlayerDetect_body_entered(body):
	if body.name == "Player":
		get_target_path(player.global_transform.origin)
	state = "chase"
func _on_PlayerDetect_body_exited(body):
	if body.name == "Player":
		var vec = player.global_transform.origin
		get_target_path(vec)
	state = "track"
