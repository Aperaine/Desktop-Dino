extends Control

signal gameStart

@onready var cursor: Area2D = %Cursor

@export var dino: CharacterBody2D
@export var started:bool = false

var passthrough : PackedVector2Array
var projectRes := Vector2(1152,648)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if !cursor.colliding:
		return
		
	elif !started:
		if Input.is_action_just_pressed("jump"):
			started = true
			emit_signal("gameStart")
			print("started")
			
			dino.jump()
			dino.set_physics_process(true)
	
	
