extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_vars(time: float, zomb:float, batt:float) -> void:
	get_node("ColorRect/MarginContainer/VBoxContainer/timeVar").text = String(int(time))
	get_node("ColorRect/MarginContainer/VBoxContainer/zomVar").text = String(zomb)
	get_node("ColorRect/MarginContainer/VBoxContainer/batVar").text = String(batt)


func _on_Button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
