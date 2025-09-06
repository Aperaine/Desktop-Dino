extends Node2D

signal enteredScreen

@export var dirPath : String
@export var speed:float = 0
@export var startingDelay : Timer
@export var mainSpawner : Node2D
@export var birdFile : PackedScene

@onready var cactiDirectory = DirAccess.open(dirPath)
@onready var spawnPosition = position

var cactiArray:Array
var original:bool
var move:bool = false

var secondCactusThreshold:float = 0.8
var birdThreshold:float = 0.4
var birdsAllowed:bool = false
var birdSpawnY : Array = [-178,-229,-280,-331]

var birdSpeedMultiplier : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original = self==mainSpawner
	
	speed = 0
	SignalBus.connect("updateSpeed", updateSpeed)
	
	cactiDirectory.list_dir_begin()
	for file: String in cactiDirectory.get_files():
		var resource := load(
			(
				cactiDirectory.get_current_dir() + "/" + file
			).trim_suffix(".remap")
			)
		cactiArray.append(resource)
	#print(cactiArray)
	
	if !original:
		SignalBus.connect("birdsAllowed",birdsAreAllowed)
	
	randomize()

func spawnCactus():
	birdSpeedMultiplier = 1
	position = spawnPosition
	
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

func spawnBird():
	position.y = birdSpawnY.pick_random()
	
	birdSpeedMultiplier = randf_range(1.05,1.2)
	for child in get_children(false):
		if child is Area2D:
			child.queue_free()
	
	var bird = birdFile.instantiate()
	add_child(bird)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move:
		position.x -= speed * delta * birdSpeedMultiplier


func screen_exited() -> void:
	position.x = spawnPosition.x
	if original:
		spawnCactus()
	else:
		move = false
		await mainSpawner.enteredScreen
		move= true
		
		
		var ranumber = randf()
		#print(ranumber)
		if ranumber < birdThreshold && birdsAllowed:
			spawnBird()
			#print("birdSpawn")
		elif ranumber >= secondCactusThreshold:
			spawnCactus()

func updateSpeed(tempspeed:float):
	speed = tempspeed


func _on_game_restart() -> void:
	for child in get_children(false):
		if child is Area2D:
			child.queue_free()
	move = false
	position = spawnPosition
	
	birdsAllowed = false
	
	startingDelay.stop()


func _on_game_game_start() -> void:
	birdsAllowed=false
	birdSpeedMultiplier = 1
	
	startingDelay.start()
	await startingDelay.timeout
	
	if original:
		move = true
		spawnCactus()
	else:
		await mainSpawner.enteredScreen
		move = true
		var ranumber = randf()
		
		if ranumber < birdThreshold && birdsAllowed:
			spawnBird()
			#print("birdSpawn")
		elif ranumber > secondCactusThreshold:
			spawnCactus()


func _screen_entered() -> void:
	
	enteredScreen.emit()

func birdsAreAllowed():
	birdsAllowed = true
	print("birdsallowed")
