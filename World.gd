extends Node2D

enum {
	RED,
	BLUE
}

enum {
	HOLD,
	DROP
}

enum {
	YHOLD,
	YDROP
}

onready var camera = $Camera2D
onready var player1 = $Player
onready var redhusk = $red_husk
onready var player2 = $player2
onready var rotater = $rotater
onready var point = $point
onready var platform = $platform

var state = RED
var cubeState = DROP
var rotateAmount
var touchingBox = false
var whoTouchBox
var holdingBox
var inControl
var bluePlate = 0
var redPlate = 0
var boxPlate = 0
var yellowPlate = 0
var yellowTouch
var whoTouchYellow
var whoHoldYellow
var holdingYellow
var cubeYellowState = YDROP

var whoHoldBox
var mute = -100

## HOW MANY PLATES NEEDED TO OPEN DOOR
const SCORE = 2
var win = false

func _ready():
	$music/reverb_phone.volume_db = mute
	$music/reverb_chords.volume_db = mute
	$music/deep_buzz.volume_db = mute
	
	$gate/AnimationPlayer.play("blinking")
	$gate2/AnimationPlayer.play("blinking")
	
	$yellow_gate/AnimationPlayer.play('blinking')
	$yellow_gate2/AnimationPlayer.play('blinking')
	$yellow_gate3/AnimationPlayer.play('blinking')
	
	$red_gate/AnimationPlayer.play('blinking')
	$red_gate2/AnimationPlayer.play('blinking')
	$red_gate3/AnimationPlayer.play('blinking')
	
	$blue_gate/AnimationPlayer.play('blinking')
	$blue_gate2/AnimationPlayer.play('blinking')
	
	$exit_door/Area2D/CollisionShape2D.disabled = true
	$exit_door/AnimatedSprite.frame = 0
	
	$fade/AnimationPlayer.play("fade_from")
	
	for i in $music.get_children():
		if i.playing == false:
			i.play()

func _physics_process(delta):
	fallen(player1)
	fallen(player2)
	fallen($cube)
	fallen($big_box)
	
#	for i in $music.get_children():
#		if i.playing == false:
#			i.play()
		
	var numButtons = redPlate + bluePlate + boxPlate + yellowPlate
	var scorePlate = redPlate + bluePlate
	
	if numButtons == 0:
		$music/reverb_phone.volume_db = mute
		$music/reverb_chords.volume_db = mute
		$music/deep_buzz.volume_db = mute
		
	if numButtons == 1:
		$music/reverb_phone.volume_db = mute
		$music/reverb_chords.volume_db = mute
		$music/deep_buzz.volume_db = 0
		
	if numButtons == 2:
		$music/reverb_phone.volume_db = 0
		$music/reverb_chords.volume_db = mute
		$music/deep_buzz.volume_db = 0
		
	if numButtons == 3:
		$music/reverb_phone.volume_db = 0
		$music/reverb_chords.volume_db = 0
		$music/deep_buzz.volume_db = 0
		
	if scorePlate == SCORE:
		$exit_door/AnimatedSprite.frame = 1
		$exit_door/Area2D/CollisionShape2D.disabled = false
	
	# PLACE CAMERA BETWEEN BOTH PLAYERS
	$center.position.y = camera.position.y
	var playerCenter = (player2.global_position + player1.global_position) * .5
	camera.global_position = (playerCenter + $center.global_position) * .5
	camera.global_position.y = camera.global_position.y - 25
	
	# CHANGE WHICH PLAYER IS SELECTED
	match state:
		RED:
			red()
		BLUE:
			blue()
			
	match cubeState:
		HOLD:
			hold()
		DROP:
			drop()
			
	match cubeYellowState:
		YHOLD:
			yhold()
		YDROP:
			ydrop()
			
	# CAMERA
	var distance = sqrt(pow((player2.position.x - player1.position.x), 2) + pow((player2.position.y - player1.position.y), 2)) # get distance between players
	distance = distance * 0.0015
#	if Input.is_action_pressed("right_click"):
#		camera.global_position = (player2.global_position + player1.global_position) * .5 #place camera between players
#		print(distance)
#		camera.zoom = Vector2(distance, distance) #change zoom based on distance of players
#		camera.offset_v = -0.10
#	else:
#		camera.zoom = Vector2(0.50, 0.50) # reset zoom
#		camera.offset_v = -0.35
	
	
	# CAMERA ROTATE
	
	var objCenter = ((player1.global_position.x + player2.global_position.x) + ($big_box.global_position.x * 0.8) + ($cube.global_position.x * 0.5) + ($yellow_box.global_position.x * 0.5)) * 0.5 # get center of characters
	rotateAmount = (objCenter + 0) * 0.5 # get center of objects and x = 0
	#rotateAmount = (rotateAmount + $big_box.global_position.x + $cube.global_position.x) * 0.5 
	point.global_position.x = rotateAmount # displays marker
	
	
	camera.rotation_degrees -= rotateAmount * 0.001 # rotates the camera based on distance to center

	#print(touchingBox)
	

#	print(rotateAmount * 0.00001)
#	print(camera.rotation_degrees)
	
	if Input.is_action_just_pressed("r_key"):
		get_tree().reload_current_scene()
		
	if camera.rotation_degrees >= 32 or camera.rotation_degrees <= -38:
		get_tree().reload_current_scene()


	# switch controlls
	if Input.is_action_just_pressed("left_click") and state == RED:
		state = BLUE
#		$soul_particles.global_position.x += move_toward(player1.global_position.x, player2.global_position.x, delta)
#		$soul_particles.global_position.y += move_toward(player1.global_position.y, player2.global_position.y, delta)
	elif Input.is_action_just_pressed("left_click") and state == BLUE:
		state = RED
#		$soul_particles.global_position.x = move_toward(player2.global_position.x, player1.global_position.x, delta)
#		$soul_particles.global_position.y = move_toward(player2.global_position.y, player1.global_position.y, delta)
		
		
	if touchingBox == true and whoTouchBox == inControl and Input.is_action_just_pressed("right_click"):
		cubeState = HOLD
		whoHoldBox = whoTouchBox
	if holdingBox == true and whoHoldBox == inControl and Input.is_action_just_pressed("right_click"):
		cubeState = DROP
		
	if yellowTouch == true and whoTouchYellow == inControl and Input.is_action_just_pressed("right_click"):
		cubeYellowState = YHOLD
		whoHoldYellow = whoTouchYellow
	if holdingYellow == true and whoHoldYellow == inControl and Input.is_action_just_pressed("right_click"):
		cubeYellowState = YDROP


func red():
	player1.state = 1
	player2.state = 0
	inControl = player1
	$Player/indicator.visible = true
	$player2/indicator.visible = false
	
func blue():
	player1.state = 0
	player2.state = 1
	inControl = player2
	$Player/indicator.visible = false
	$player2/indicator.visible = true


func fallen(obj):
	if obj.global_position.y >= 500:
		get_tree().reload_current_scene()

#func die(obj):
#	for i in obj.get_node("CollisionShape2d"):
#		i.disabled = true

func smallBoxTouched(body):
	touchingBox = true
	whoTouchBox = body


func _on_Area2D_body_exited(body):
	touchingBox = false
	
func hold():
	$cube.position.x = whoHoldBox.position.x
	$cube.position.y = whoHoldBox.position.y - 10
	$cube.state = 1
	holdingBox = true
	
func drop():
	$cube.state = 0
	holdingBox = false
	
func yhold():
	$yellow_box.position.x = whoHoldYellow.position.x
	$yellow_box.position.y = whoHoldYellow.position.y - 10
	$yellow_box.state = 1
	holdingYellow = true
	
func ydrop():
	$yellow_box.state = 0
	holdingYellow = false

func button_control():
	pass

func blue_plate_triggered(area):
	$blue_plate/Sprite.frame = 1
	bluePlate = 1
	$blue_gate/AnimationPlayer.play('open')
	$blue_gate2/AnimationPlayer.play('open')

func blue_plate_released(area):
	$blue_plate/Sprite.frame = 0
	bluePlate = 0
	$blue_gate/AnimationPlayer.play('close')
	$blue_gate2/AnimationPlayer.play('close')
	$blue_gate/AnimationPlayer.queue('blinking')
	$blue_gate2/AnimationPlayer.queue('blinking')

func red_plate_triggered(area):
	$red_plate/AnimatedSprite.frame = 1
	redPlate = 1
	$red_gate/AnimationPlayer.play('open')
	$red_gate2/AnimationPlayer.play('open')
	$red_gate3/AnimationPlayer.play('open')

func red_plate_released(area):
	$red_plate/AnimatedSprite.frame = 0
	redPlate = 0
	$red_gate/AnimationPlayer.play('close')
	$red_gate/AnimationPlayer.queue("blinking")
	
	$red_gate2/AnimationPlayer.play('close')
	$red_gate2/AnimationPlayer.queue("blinking")
	
	$red_gate3/AnimationPlayer.play('close')
	$red_gate3/AnimationPlayer.queue("blinking")

func white_plate_triggered(area):
	$white_plate/AnimatedSprite.frame = 1
	boxPlate = 1
	$gate/AnimationPlayer.play('open')
	$gate2/AnimationPlayer.play('open')
	

func white_plate_released(area):
	$white_plate/AnimatedSprite.frame = 0
	$gate/AnimationPlayer.play("close")
	$gate/AnimationPlayer.queue("blinking")
	
	$gate2/AnimationPlayer.play("close")
	$gate2/AnimationPlayer.queue("blinking")


func trash_this(body):
	body.queue_free()


func yellowBoxTouched(body):
	print(body)
	yellowTouch = true
	whoTouchYellow = body


func yellowBoxLeave(body):
	yellowTouch = false


func yellow_plate_triggered(area):
	$yellow_plate/AnimatedSprite.frame = 1
	yellowPlate = 1
	$yellow_gate/AnimationPlayer.play('open')
	$yellow_gate2/AnimationPlayer.play('open')
	$yellow_gate3/AnimationPlayer.play('open')


func yellow_plate_released(area):
	$yellow_plate/AnimatedSprite.frame = 0
	yellowPlate = 0
	$yellow_gate/AnimationPlayer.play('close')
	$yellow_gate/AnimationPlayer.queue("blinking")
	
	$yellow_gate2/AnimationPlayer.play('close')
	$yellow_gate2/AnimationPlayer.queue("blinking")
	
	$yellow_gate3/AnimationPlayer.play('close')
	$yellow_gate3/AnimationPlayer.queue("blinking")
