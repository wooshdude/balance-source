extends KinematicBody2D

enum {
	IDLE,
	HELD
}

export (int) var gravity = 600
export (float) var friction = 0.2
var velocity = Vector2.ZERO
var state = IDLE


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	match state:
		IDLE:
			idle(delta)
		HELD:
			held()
			
func held():
	$CollisionShape2D.disabled = true
	
func idle(delta):
	$CollisionShape2D.disabled = false
	velocity.y += gravity * delta / 2
	velocity = move_and_slide(velocity, Vector2.UP,
					false, 4, PI/4, false)
	
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, friction)
