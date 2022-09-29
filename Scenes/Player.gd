extends KinematicBody2D
var velocity = Vector2.ZERO #no direction
export var max_speed = 100
export(int) var gravity = 4
export(int) var jump_speed = -200
export(int) var jump_release = -50
export(int) var friction = 20
export(int) var additional_gravity = 10
var fast_fell = false 


func _physics_process(delta):
	apply_gravity() #gravity pulling it down
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)
	
	if is_on_floor():
		if Input.is_action_pressed("jump"): # can hold down jump button to keep jumping
			velocity.y = jump_speed #jump height
	else:
		if Input.is_action_just_released("jump") and velocity.y < jump_release:
			velocity.y = jump_release #jump release height, longer the jump button is pressed higher the jump
		
		if velocity.y > 0:
			velocity.y += additional_gravity
			
	
	velocity = move_and_slide(velocity, Vector2.UP) #move character and detect/handle collisions

func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, 1000)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, friction)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, max_speed * amount, 15) 
	pass
	
