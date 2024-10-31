extends CharacterBody2D

# Variables
var speed = 200              # Horizontal movement speed
var acceleration = 10        # Horizontal acceleration
var gravity = 900            # Gravity
var jump_force = -350        # Jump force (negative because up is -y)


# State variables  
var is_jumping = false       # Is the player jumping?


# Called every frame
func _physics_process(delta):
	# Handle horizontal movement
	var input_dir = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if input_dir != 0:
		velocity.x = lerp(velocity.x, input_dir * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true

	

	# Apply movement
	move_and_slide()

	# Reset jump on landing
	if is_on_floor() and is_jumping:
		is_jumping = false
