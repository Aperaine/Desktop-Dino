extends Control

signal gameStart
signal updateSpeed(speed:float)
signal restart

@onready var cursor: Area2D = %Cursor

@export var ground:Node2D
@export var dino: CharacterBody2D
@export var running:bool = false
@export var speed:float


const STARTINGSPEED:int = 700

var passthrough : PackedVector2Array
var projectRes := Vector2(1152,648)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	#actual code
	if !running:
		if Input.is_action_just_pressed("jump"):
			speed = STARTINGSPEED
			running = true
			emit_signal("gameStart")
			emit_signal("updateSpeed", speed)
			print("started")
			
			dino.jump()
			dino.movementAllowed = true
	
	#testing
	elif Input.is_action_just_pressed("crouch"):
		gameOver()
	elif Input.is_action_just_pressed("ui_accept"):
		newGame()

	

func gameOver():
	print("gameover")
	
	running = true
	speed = 1
	ground.set_process(false)
	dino.death()

func newGame():
	print("newgame")
	
	emit_signal("restart")
	running = false
	dino._ready()
