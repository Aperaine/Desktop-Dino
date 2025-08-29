extends RichTextLabel

const pulse := "[pulse freq=5 color=gold ease=1]"

@export var score := 0
@export var high := 0

var scoreEffect = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setScore():
	text = "[color=gray]HI %h\n[color=white]%e%s" % [str(high),str(score),scoreEffect]
