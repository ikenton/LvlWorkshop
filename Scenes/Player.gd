extends KinematicBody2D
var velocity = Vector2.ZERO #no direction
export var max_speed = 100
export(int) var gravity = 4
export(int) var jump_speed = -130
export(int) var jump_release = -70
export(int) var friction = 10
export(int) var acceleration = 15
export(int) var additional_gravity = 10
var fast_fell = false 


func _physics_process(delta):
	apply_gravity() #gravity pulling it down
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	if input.x == 0:
		$AnimatedSprite.animation = "idle"
		apply_friction()
	else:
		apply_acceleration(input.x)
		$AnimatedSprite.animation = "run"
		if input.x > 0:
			$AnimatedSprite.flip_h = true
		elif input.x < 0:
			$AnimatedSprite.flip_h = false
	
	if is_on_floor():
		if Input.is_action_pressed("jump"): # can hold down jump button to keep jumping
			velocity.y = jump_speed #jump height
	else:
		if Input.is_action_just_released("jump") and velocity.y < jump_release:
			velocity.y = jump_release #jump release height, longer the jump button is pressed higher the jump
		
		if velocity.y > 0:
			velocity.y += additional_gravity
			
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP) #move character and detect/handle collisions
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.frame = 1
func apply_gravity():
	velocity.y += gravity
	velocity.y = min(velocity.y, 1000)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, friction)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, max_speed * amount, acceleration) 
	pass


func _on_OutOfBounds_body_entered(body):
	get_tree().change_scene("res://Scenes/Platform.tscn")


func _on_WinCondition_body_entered(body):
	get_tree().change_scene("res://Scenes/Platform.tscn")
	print("DEBUG: YOU WIN")


func _on_Area2D_body_entered(body):
	get_tree().change_scene("res://Scenes/Platform.tscn")
