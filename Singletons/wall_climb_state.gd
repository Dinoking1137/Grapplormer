class_name WallClimbState
extends State

func enter() -> void:
	print("Entering Wall Climb State")
	sm.playerBody2D.velocity.x = 0
	print("Enter Direction: " + str(sm.enterDirection))
	sm.isGravity = true
	sm.isYellowOrb = true
	sm.isPinkOrb = true
	sm.isBlueOrb = true
	sm.isGreenOrb = true
	sm.isBlackOrb = true
	
func exit() -> void:
	print("Exiting Wall Climb state")
	
func update(delta: float) -> void:
	
	if Input.is_action_just_pressed("click"):
		sm.transition_to("attack_grapple")
	
	handleLetGo()
	handleIsJump()
	
	#
	#if input_axis != 0:
		#sm.playerBody2D.velocity.y = sm.playerBody2D.velocity.y
	#else:
	
	if sm.wallJumpBufferTime > sm.wallJumpBuffer:
		sm.playerBody2D.velocity.y = move_toward(sm.playerBody2D.velocity.y, sqrt(sm.playerBody2D.velocity.y * sm.wallJumpBufferTime) * 4.0, sm.ACCELERATION * delta)
	else:
		sm.playerBody2D.velocity.y = 0
	
	if sm.isJump:
		sm.playerBody2D.velocity = Vector2( sm.enterDirection * -sm.MAX_JUMP_VELOCITY / 2.0, -sm.MAX_JUMP_VELOCITY)
		sm.isJump = false
		sm.coyoteTime = sm.coyoteMax
		print("WALLJUMP")
		transitionOnWallJump()
		
	
func on_click(tag: String) -> void:
	pass

func handleIsJump() -> void:
	
	if Input.is_action_just_pressed("jump"):
		sm.isJump = true
	
	if Input.is_action_just_released("jump"):
		sm.isJump = false

func handleLetGo() -> void:
	
	var input_axis := Input.get_axis("left", "right")
	sm.coyoteTime = 0.0
	#print("input_axis: " + str(input_axis))
	
	if !sm.playerBody2D.is_on_wall() || input_axis != sm.enterDirection:
		if sm.playerBody2D.is_on_floor():
			sm.transition_to("grounded")
		else:
			sm.transition_to("air")

func transitionOnWallJump() -> void:
	
	#sm.coyoteTime = 0.0
	if sm.playerBody2D.is_on_floor():
		sm.transition_to("grounded")
	else:
		sm.transition_to("air")

func rotateVector(v: Vector2, angle: float) -> Vector2:
	
	var theta := deg_to_rad(angle)
	var cosine := cos(theta)
	var sine := sin(theta)
	
	return Vector2(
		v.x * cosine - v.y * sine,
		v.x * sine + v.y * cosine
	)
