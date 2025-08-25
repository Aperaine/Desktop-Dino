extends Node2D

@export var groundScene:PackedScene

var speed:int = 50
var instances:int = 1
var groundWidth:int = 17840

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= speed * delta


func _on_game_game_start() -> void:
	var tween = create_tween()
	set_process(true)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(0,-72), 0.5)


func _on_game_update_speed(sspeed: int) -> void:
	speed = sspeed


func _on_ground_next_iteration() -> void:
	print("nearEndRecieved")
	var newGround = groundScene.instantiate()
	newGround.position = Vector2(groundWidth * instances, 0)
	newGround.connect("nextIteration", _on_ground_next_iteration)
	
	instances += 1
	add_child(newGround)
	print(newGround)
