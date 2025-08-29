extends Node2D

@export var groundScene:PackedScene

const STARTINGPOS := Vector2(0,550)

@export var speed:float = 0
var instances:int = 0
var groundWidth:int = 17840

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	SignalBus.connect("updateSpeed",_on_game_update_speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= speed * delta


func _on_game_game_start() -> void:
	for child in get_children():
		child.queue_free()
	
	position = STARTINGPOS
	instances = 0
	_on_ground_next_iteration()
	
	
	var tween = create_tween()
	set_process(true)
	
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(0,-72), 0.3)


func _on_game_update_speed(sspeed: float) -> void:
	speed = sspeed


func _on_ground_next_iteration() -> void:
	var newGround = groundScene.instantiate()
	newGround.position = Vector2(groundWidth * instances, 0)
	newGround.connect("nextIteration", _on_ground_next_iteration)
	
	instances += 1
	add_child(newGround)



func _on_game_restart() -> void:
	set_process(false)
	
	var tween = create_tween()
	
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", Vector2(position.x, STARTINGPOS.y), 0.3)
