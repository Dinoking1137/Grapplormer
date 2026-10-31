class_name GroundedState
extends State

func enter() -> void:
	print("Entering Grounded State")
	sm.isGravity = true
	sm.isYellowOrb = true
	sm.isPinkOrb = true
	sm.isBlueOrb = true
	sm.isGreenOrb = true
	sm.isBlackOrb = true
	
func exit() -> void:
	print("Exiting Grounded state")
	
func update(delta: float) -> void:
	
	var input_axis := Input.get_axis("left", "right")
	var target_velocity = input_axis * sm.MAX_SPEED
	
	if sm.playerBody2D.is_on_wall() && input_axis != 0:
		print("Is Transitioning to wall Climb")
		sm.wallJumpBufferTime = 0
		sm.transition_to("wall_climb")
	
	if !sm.playerBody2D.is_on_floor():
		sm.transition_to("air")
	
	if Input.is_action_just_pressed("click"):
		sm.transition_to("grapple")
	
	handleIsJump()
	
	# Acceleration
	if input_axis != 0:
		sm.enterDirection = sign(target_velocity)
		sm.playerBody2D.velocity.x = move_toward(sm.playerBody2D.velocity.x, target_velocity, sm.ACCELERATION * delta)
	else:
		sm.playerBody2D.velocity.x = move_toward(sm.playerBody2D.velocity.x, 0, sm.ACCELERATION * delta)
	
	if sm.isJump && sm.coyoteTime < sm.coyoteMax:
		sm.playerBody2D.velocity.y = -sm.MAX_JUMP_VELOCITY
		sm.isJump = false
		sm.coyoteTime = sm.coyoteMax
		print("JUMP")
	
func on_click(tag: String) -> void:
	pass
	
func handleIsJump() -> void:
	
	if Input.is_action_just_pressed("jump"):
		sm.isJump = true
	
	if Input.is_action_just_released("jump"):
		sm.isJump = false
