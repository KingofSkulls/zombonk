extends Spatial

const TombstoneCount = 10
const BatteryCount = 10

onready var Tombstone = load("res://Scenes/Tombstone.tscn")
onready var Battery = load("res://Scenes/battery.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var pos_list := $TombstoneSpawns.get_children()
	
	for i in range(TombstoneCount):
		var chosen_idx := randi() % len(pos_list)
		var chosen_tombstone = pos_list[chosen_idx]
		pos_list.pop_at(chosen_idx)
		
		var tmp_tombstone = Tombstone.instance()
		
		tmp_tombstone.translation = chosen_tombstone.translation + Vector3(0, 1, 0)
		
		$Navigation.add_child(tmp_tombstone)
		
	for i in range(BatteryCount):
		var chosen_idx := randi() % len(pos_list)
		var chosen_pos = pos_list[chosen_idx]
		pos_list.pop_at(chosen_idx)
		
		var tmp_batter = Battery.instance()
		
		tmp_batter.translation = chosen_pos.translation + Vector3(0, 1.5, 0)
		
		$Navigation.add_child(tmp_batter)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
