extends Node2D

signal nextIteration

func nearingEnd() -> void:
	emit_signal("nextIteration")



func screen_exited() -> void:
	queue_free()
