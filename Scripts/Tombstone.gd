extends Spatial

export var ZombieCDMin := 70.0
export var ZombieCDMax := 180.0
var ZombieCooldown: float

onready var Zombie = load("res://Scenes/Zombie.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_cd()
	ZombieCooldown -= ZombieCDMin
	
func new_cd() -> void:
	ZombieCooldown = randi() % int(ZombieCDMax - ZombieCDMin) + ZombieCDMin

func spawn_zombie() -> void:
	var tmp_zombie = Zombie.instance()
	
	tmp_zombie.translation = translation
	
	get_parent().add_child(tmp_zombie)
	
	new_cd()

func _process(delta) -> void:
	ZombieCooldown -= delta
	if ZombieCooldown <= 0:
		spawn_zombie()
