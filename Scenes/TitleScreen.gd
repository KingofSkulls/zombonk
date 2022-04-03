extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	title_slide_in(delta)
	

func _on_Start_pressed() -> void:
	get_tree().change_scene("res://Scenes/Main.tscn")

func _on_Credits_pressed() -> void:
	pass # Replace with credits screen when it is finished


func _on_Exit_pressed() -> void:
	get_tree().quit()



func _on_Start_mouse_entered() -> void:
	get_node("Hand").rect_position.y = 382


func _on_Credits_mouse_entered() -> void:
	get_node("Hand").rect_position.y = 437
	
func _on_Exit_mouse_entered() -> void:
	get_node("Hand").rect_position.y = 494



func title_slide_in(delta: float) ->void:
	var  slideSpeed: float = 400.0
	if(get_node("TitleText").rect_position.y < -220):
		get_node("TitleText").rect_position.y += slideSpeed * delta

