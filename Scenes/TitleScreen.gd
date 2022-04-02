extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Start_pressed() -> void:
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_Credits_pressed() -> void:
	pass # Replace with credits screen when it is finished


func _on_Exit_pressed() -> void:
	get_tree().quit()
