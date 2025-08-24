extends Area2D
var colliding:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position()
	if colliding:
		get_window().mouse_passthrough = false
	else:
		get_window().mouse_passthrough = true


func _on_area_entered(area: Area2D) -> void:
	colliding = true
	print(colliding)


func _on_area_exited(area: Area2D) -> void:
	colliding = false
	print(colliding)
