extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal batteryCollected
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	rotate_y(delta*2) #rotates in degrees

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Battery_body_entered(body):
	if body.name == "Player":
		emit_signal("batteryCollected")
		queue_free()
