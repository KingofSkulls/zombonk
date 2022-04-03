extends Camera
# code provided by Code with Tom
#at https://www.youtube.com/watch?v=Myr9-6A0wqE
export var camera_path : NodePath

var camera : Camera

func _ready():
	camera = get_node(camera_path)
	
func _process(delta):
	global_transform = camera.global_transform
