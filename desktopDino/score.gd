extends RichTextLabel

const pulse := "[pulse freq=10 color=gold ease=1]"

@export var score :float = 0
@export var high : int = 0

var scoreEffect = ""
var config = ConfigFile.new()

@onready var birdsAllowed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.TRANSPARENT
	
	set_process(false)
	score = 0
	config.load("user://scores.cfg")
	high = config.get_value("scores","high",0)
	setScore()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	score += 10 * delta
	if int(score) % 100 < 10 && score >= 100:
		if scoreEffect != pulse:
			scoreEffect = pulse
			setScore()
	else:
		scoreEffect = ""
		setScore()
	
	if score >= 400 && !birdsAllowed:
		SignalBus.birdsAllowed.emit()
		birdsAllowed = true

func setScore():
	var tempText = "[color=gray]HI %s [color=white]%s%s "# % returnStringWithZeroes(high)#,returnStringWithZeroes(score),scoreEffect
	text = tempText % [returnStringWithZeroes(high),scoreEffect,returnStringWithZeroes(int(score))]

func returnStringWithZeroes(num:int):
	var numString = str(num)
	
	if num < 10:
		return( "0000" + numString )
	elif num < 100:
		return( "000" + numString )
	elif num < 1000:
		return ("00" + numString)
	elif num < 10000:
		return ("0" + numString)
	else:
		return ( numString )


func _on_game_start() -> void:
	birdsAllowed = false
	set_process(true)
	
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color.WHITE,1)


func _on_game_restart() -> void:
	score = 0
	
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color.TRANSPARENT,0.2)

func updateHigh():
	if score > high:
		high = score
		config.set_value("scores","high",high)
		config.save("user://scores.cfg")
		
	scoreEffect = ""
	setScore()
