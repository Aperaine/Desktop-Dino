extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree


const JUMP_VELOCITY = -900
const GRAVITY_MULTIPLIER = 3

@export var movementAllowed:=false

@export var crouch := false
@export var hurt := false


func _ready() -> void:
	set_physics_process(true)
	hurt = false
	movementAllowed = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity += get_gravity() * delta * GRAVITY_MULTIPLIER
		else:
			velocity += get_gravity() * delta * 2
	
	if movementAllowed:
		movement()
	
	move_and_slide()

func jump() -> void:
	animation_tree.set("parameters/conditions/run", true)
	
	velocity.y = JUMP_VELOCITY

func death():
	animation_tree.set("parameters/conditions/run", false)
	hurt = true
	set_physics_process(false)

func movement():
	
	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		jump()
	
	crouch = Input.is_action_pressed("crouch")
