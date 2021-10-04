extends KinematicBody2D

enum {
	IDLE,
	MOVE,
	SLAM,
	INTERACT
}

onready var timer = $Timer

export (int) var speed = 150
export (int) var jump_speed = -300
export (int) var gravity = 600
export (float) var friction = 0.2
export (float) var acceleration = 0.25
export (int, 0, 200) var push = 5

var velocity = Vector2.ZERO
var state = MOVE
var jump = false
var jumpTime = 0

func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
		MOVE:
			move(delta)
		SLAM:
			slam(delta)
		INTERACT:
			pass

# MOVEMENT

func move(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var jump_pressed = Input.is_action_pressed('ui_select') #jump button is keep pressed
	var jump_cut = Input.is_action_just_released('ui_select')  #jump button just released
	var jump = Input.is_action_just_pressed('ui_select')   #jump button is just pressed

	if jump && is_on_floor():  # check if the jump button is just pressed and if the player is on the floor
		jump() # call jump method
	if velocity.y < 0 && !jump_pressed: # here is the deal: if the jump button is not keep pressed anymore, the y velocity is set to 0 and the player don't go up anymore
		velocity.y = lerp(velocity.y, 0, lerp(0, 1, 0.1))
		
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Bodies"):
			collision.collider.apply_central_impulse(-collision.normal * push)
	
func jump():
	velocity.y = jump_speed

func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
		
#	if Input.is_action_pressed("ui_down"):
#		state = SLAM

func idle(delta):
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, friction)

# SLAM

func slam(delta):
	timer.start()

func _on_Timer_timeout(delta):
	velocity.y += gravity * delta * 8
	velocity = move_and_slide(velocity, Vector2.UP)
	state = MOVE


















