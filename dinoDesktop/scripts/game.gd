extends Control

signal gameStart

@export var dino: CharacterBody2D
@export var dinoButton : Window
#@export var passthroughPolygon: Polygon2D

var passthrough : PackedVector2Array
var projectRes := Vector2(1152,648)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(dinoButton.position)
	
	var temp: Vector2 = dinoButton.position
	temp.x *= DisplayServer.window_get_size().x / projectRes.x
	temp.y *= DisplayServer.window_get_size().y / projectRes.y
	temp.y += dinoButton.size.y*2
	print(DisplayServer.window_get_size())
	print(DisplayServer.screen_get_size())
	dinoButton.position = temp
	print(dinoButton.position)
	
	dinoButton.size.x  *= DisplayServer.window_get_size().x / projectRes.x
	dinoButton.size.y *= DisplayServer.window_get_size().y / projectRes.y
	
	get_window().mouse_passthrough = true
	
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	print("boop")
	emit_signal("gameStart")
