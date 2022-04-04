extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HandTween.interpolate_property($Hand, "rect_position", 
		Vector2($Hand.rect_position.x, $Hand.rect_position.y), Vector2($Hand.rect_position.x, 494), 1.5)
	$HandTween.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	title_slide_in(delta)

func _on_Start_pressed() -> void:
	get_tree().change_scene("res://Scenes/Main.tscn")
	
func _on_How_To_Play_pressed() -> void:
	get_tree().change_scene("res://Scenes/howToPlay.tscn")

func _on_Credits_pressed() -> void:
	get_tree().change_scene("res://Scenes/Credit.tscn")

func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_Start_mouse_entered() -> void:
	$HandTween.remove_all()
	$HandTween.interpolate_property($Hand, "rect_position", 
		Vector2($Hand.rect_position.x, $Hand.rect_position.y), Vector2($Hand.rect_position.x, 382), 0.1)
	$HandTween.start()

func _on_How_To_Play_mouse_entered() -> void:
	pass # fill in based on the others

func _on_Credits_mouse_entered() -> void:
	$HandTween.remove_all()
	$HandTween.interpolate_property($Hand, "rect_position", 
		Vector2($Hand.rect_position.x, $Hand.rect_position.y), Vector2($Hand.rect_position.x, 437), 0.1)
	$HandTween.start()
	
func _on_Exit_mouse_entered() -> void:
	$HandTween.remove_all()
	$HandTween.interpolate_property($Hand, "rect_position", 
		Vector2($Hand.rect_position.x, $Hand.rect_position.y), Vector2($Hand.rect_position.x, 494), 0.1)
	$HandTween.start()
	

func title_slide_in(delta: float) ->void:
	var  slideSpeed: float = 400.0
	if(get_node("bonkText").rect_position.y < -220):
		get_node("bonkText").rect_position.y += slideSpeed * delta
	else:
		get_node("bonkText").hide()
		get_node("zombieText").hide()
		get_node("titleText").show()

