extends KinematicBody2D

const MAX_SPEED = 300
const ACCEL = 150
const DEACCEL = 200
const JUMP_SPEED = 150
const WALK_SPEED = 150

var velocity = Vector2()
var prev_sprite = "Idle_E"
var face_west = false

func process_deaccel():
	# deccelaration
	if velocity.x > 0:
		velocity.x = max(0, velocity.x - DEACCEL)
	elif velocity.x < 0:
		velocity.x = min(0, velocity.x + DEACCEL)

func process_animation():
	
	var cur_sprite = prev_sprite
	var flip_horz = false
	
	if velocity.x > 0:
		if velocity.x > WALK_SPEED:
			cur_sprite = "Run_E"
		else:
			cur_sprite = "Run_E"
	elif velocity.x < 0:
		flip_horz = true
		if velocity.x < -WALK_SPEED:
			cur_sprite = "Run_E"
		else:
			cur_sprite = "Run_E"
	else:
		flip_horz = face_west
		cur_sprite = "Idle_E"
		
	get_node(prev_sprite).visible = false
	
	get_node(cur_sprite).visible = true
	get_node(cur_sprite).flip_h = flip_horz
	get_node("AnimationPlayer").play(cur_sprite)
	
	prev_sprite = cur_sprite
	
func process_input():
	
	# Remove true when floor is created
	if is_on_floor() or true:

		if Input.is_action_pressed("ui_run"):
			var delta_velx = 0
			var key_pressed = false
			# Process running movement
			if Input.is_action_pressed("ui_right"):
				delta_velx += ACCEL
				key_pressed = true
			if Input.is_action_pressed("ui_left"):
				delta_velx += -ACCEL
				key_pressed = true
			
			if key_pressed:
				velocity.x += delta_velx
				velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
			else:
				process_deaccel()
		else:
			process_deaccel()
			
			# Process walking movement
			var delta_walkx = 0
			if Input.is_action_pressed("ui_right"):
				delta_walkx += WALK_SPEED
			if Input.is_action_pressed("ui_left"):
				delta_walkx += -WALK_SPEED
				
			velocity.x += delta_walkx
			velocity.x = clamp(velocity.x, -WALK_SPEED, WALK_SPEED)
		
		if Input.is_action_pressed("ui_accept"):
			velocity.y -= 0
	
	if velocity.x > 0:
		face_west = false
	elif velocity.x < 0:
		face_west = true

	process_animation()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(prev_sprite).visible = true
	get_node("AnimationPlayer").play(prev_sprite)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	process_input()
	velocity = move_and_slide(velocity)
