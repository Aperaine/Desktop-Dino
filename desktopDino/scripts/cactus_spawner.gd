extends Node2D

signal enteredScreen

@export var dirPath : String
@export var speed:float = 0
@export var startingDelay : Timer
@export var mainSpawner : Node2D

@onready var cactiDirectory = DirAccess.open(dirPath)
@onready var spawnPosition = position

var cactiArray:Array
var original:bool
var move:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original = self==mainSpawner
	
	speed = 0
	SignalBus.connect("updateSpeed", updateSpeed)
	
	cactiDirectory.list_dir_begin()
	for file: String in cactiDirectory.get_files():
		var resource := load(cactiDirectory.get_current_dir() + "/" + file)
		cactiArray.append(resource)
	#print(cactiArray)

func spawnCactus():
	for child in get_children(false):
		if child is Area2D:
			child.queue_free()
	
	
	var totalcacti := cactiArray.size()
	var cactus:Area2D = cactiArray.get(
		int(
			randf_range(0, totalcacti)
			)
		).instantiate()
	
	add_child(cactus)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move:
		position.x -= speed * delta


func screen_exited() -> void:
	position.x = spawnPosition.x
	if original:
		spawnCactus()
	else:
		move = false
		await mainSpawner.enteredScreen
		move= true
		spawnCactus()

func updateSpeed(tempspeed:float):
	speed = tempspeed


func _on_game_restart() -> void:
	for child in get_children(false):
		if child is Area2D:
			child.queue_free()
	move = false
	position = spawnPosition


func _on_game_game_start() -> void:
	startingDelay.start()
	await startingDelay.timeout
	if original:
		move = true
		spawnCactus()
	else:
		print("prewait")
		await mainSpawner.enteredScreen
		print("otherscreenentered")
		move = true
		spawnCactus()


func _screen_entered() -> void:
	
	enteredScreen.emit()
