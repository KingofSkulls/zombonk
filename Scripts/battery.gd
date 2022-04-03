extends Area

var verticaldrift =0
var driftspeed=0.0005
var vel := Vector3()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal batteryCollected
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	vel.x =0
	vel.y=0
	vel.z=0
	rotate_y(delta*2) #rotates in degrees
	verticaldrift+=driftspeed
	vel.y+=driftspeed
	transform.origin+=vel
	if abs(verticaldrift) > .02:
		driftspeed*=-1
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Battery_body_entered(body):
	if body.name == "Player":
		emit_signal("batteryCollected")
		queue_free()
