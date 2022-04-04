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
	"We should use everything but tombstones",
	"Ok I will really quick",
	"It should auto complere",
	"Needs to be EXCAT",
	"That's lore!!",
	"ITS WILL SMITH ZOMBIE",
	"He is stanced up",
	"I probably hit every button",
	"I'm a button pusher",
	"Love me some sounds",
	"I'm just a little jester",
	"He ate 71 pounds of sand and died",
	"Jokes on you I fact check everything",
	"I feel British Canadian sometimes",
	"I like armour",
	"Baguette = Wand",
	"J.J. Binks",
	"I tried to have a button",
	"The player eats my mouse",
	"We lost",
	"Ghost juice",
	"That's what someone who is saying an excuse would say",
	"I can't argue because I already left",
	"You have to play with your heart, not your brain"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_cd()
	ZombieCooldown -= ZombieCDMin
	
	var gravescript: String = quotes[randi() % len(quotes)]
	var script_words = gravescript.split(" ")
	$Quote/Viewport/Label.text = ""
	
	for i in range(len(script_words)):
		if i % 2 == 0:
			if i != 0:
				$Quote/Viewport/Label.text += "\n"
		else:
			$Quote/Viewport/Label.text += " "
		
		$Quote/Viewport/Label.text += script_words[i]
	
	$Quote/Viewport/Label.hide()
	$Quote/Viewport/Label.show()
	
	$Quote/Viewport.size = $Quote/Viewport/Label.rect_size
	
	rotation_degrees.y = randi() % 360
	
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
