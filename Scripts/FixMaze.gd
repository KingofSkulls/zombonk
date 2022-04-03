tool
extends GridMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(-100, 100):
		for y in range(-2, 2):
			for z in range(-100, 100):
				set_cell_item(x, y, z, get_cell_item(x, y, z), 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
