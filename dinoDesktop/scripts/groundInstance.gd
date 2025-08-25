extends Node2D

signal nextIteration

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func nearingEnd() -> void:
	print("nearningEnd")
	emit_signal("nextIteration")



func screen_exited() -> void:
	queue_free()
