extends KinematicBody2D

const MAX_SPEED = 200
const ACCEL = 20
const DEACCEL = 80
const JUMP_SPEED = 100

var dir = Vector2()
var velocity = Vector2()

func process_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * MAX_SPEED
	
	if is_on_floor():
		if Input.is_action_pressed("movement_jump"):
			velocity.y += JUMP_SPEED
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("Idle_right")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	process_input()
	velocity = move_and_slide(velocity)
