extends Control

signal gameStart
signal restart

@onready var cursor: Area2D = %Cursor

@export var ground:Node2D
@export var dino: CharacterBody2D
@export var running:bool = false
@export var gameEnded:bool = false
@export var speed:float
@export var scoreDisplay:RichTextLabel
@export var restartTimer:Timer
@export var deathSFX:AudioStreamPlayer
@export var htmlWallpaper:TextureRect


const STARTINGSPEED:int = 700

var passthrough : PackedVector2Array
var projectRes := Vector2(1152,648)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.gameOver.connect(gameOver)
	set_process(false)
	notification(2016)
	
	htmlWallpaper.visible = OS.get_name() == "Web"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	speed += 5 * delta
	SignalBus.updateSpeed.emit(speed)

func _notification(what: int):
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		print("unfocused")
		Engine.max_fps = 10
		
		
		if !running:
			newGame()
		else:
			SignalBus.gameOver.emit()
			await get_tree().create_timer(0.01).timeout
			newGame()
	elif what == NOTIFICATION_APPLICATION_FOCUS_IN or what == NOTIFICATION_APPLICATION_RESUMED:
		print("focused")
		Engine.max_fps = 60


func _input(_event: InputEvent) -> void:
	#actual code
	if Input.is_action_just_pressed("jump"):
		if restartTimer.is_stopped():
			if !running && !gameEnded:
				speed = STARTINGSPEED
				running = true
				emit_signal("gameStart")
				SignalBus.updateSpeed.emit(speed)
				print("started")
				
				dino.jump()
				dino.movementAllowed = true
				
				set_process(true)
			
			elif !running && gameEnded:
				newGame()
	
	#testing
	#elif Input.is_action_just_pressed("crouch"):
		#gameOver()
	#elif Input.is_action_just_pressed("ui_accept"):
		#newGame()

	

func gameOver():
	print("gameover")
	
	set_process(false)
	
	running = false
	gameEnded = true
	speed = 0
	
	SignalBus.updateSpeed.emit(speed)
	ground.set_process(false)
	dino.death()
	dino.movementAllowed = false
	
	scoreDisplay.set_process(false)
	scoreDisplay.updateHigh()
	
	deathSFX.play()
	

func newGame():
	print("newgame")
	gameEnded = false
	emit_signal("restart")
	running = false
	dino._ready()
	dino.movementAllowed = false
	
	restartTimer.start()
