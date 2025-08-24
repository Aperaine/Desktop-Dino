extends Control

signal gameStart

@export var dino: CharacterBody2D
@export var dinoButton : Window
#@export var passthroughPolygon: Polygon2D

var passthrough : PackedVector2Array
var projectRes := Vector2(1152,648)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
