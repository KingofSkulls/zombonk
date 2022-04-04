extends Spatial

export var ZombieCDMin := 70.0
export var ZombieCDMax := 180.0
var ZombieCooldown: float

onready var Zombie = load("res://Scenes/Zombie.tscn")

var quotes := [
	"We lost you",
	"I used to be alive",
	"Hapy Ghoust",
	"Which will be max",
	"Wario",
	"Mantha",
	"Wick",
	"Frog",
	"ShatteredBouquet"
] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_cd()
	ZombieCooldown -= ZombieCDMin
	
	var gravescript: String = quotes[randi() % len(quotes)]
	var script_words = gravescript.split(" ")
	var text_on_grave := ""
	
	for i in range(len(script_words)):
		if i % 2 == 0:
			if i != 0:
				text_on_grave += "\n"
		else:
			text_on_grave += " "
		
		text_on_grave += script_words[i]
	
	$Quote/Viewport/Label.text = text_on_grave
	
	$Quote/Viewport.size = $Quote/Viewport/Label.rect_size
	print($Quote/Viewport.size)
	
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
