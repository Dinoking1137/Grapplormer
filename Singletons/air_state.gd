class_name AirState
extends State

var isClick: bool = false
var isOrbClick: bool = false

func enter() -> void:
	print("Entering Air State")
	sm.isGravity = true
	sm.isYellowOrb = true
	sm.isPinkOrb = true
	sm.isBlueOrb = true
	sm.isGreenOrb = true
	sm.isBlackOrb = true
	
func exit() -> void:
	print("Exiting Air state")
	
func handle_movement() -> void:
	pass
	
func update(delta: float) -> void:
	
	var input_axis := Input.get_axis("left", "right")
	var target_velocity = input_axis * sm.MAX_SPEED
	
	if sm.playerBody2D.is_on_wall() && input_axis != 0:
		print("Is Transitioning to wall Climb")
		sm.wallJumpBufferTime = 0
		sm.transition_to("wall_climb")
	
	if sm.playerBody2D.is_on_floor():
		sm.isDoubleJump = true
		sm.transition_to("grounded")
		
	if Input.is_action_just_pressed("click"):
		sm.transition_to("grapple")
	
	handleIsJump()
	#handleCoyoteTime(delta)
	
	# Acceleration
	if input_axis != 0:
		sm.enterDirection = sign(target_velocity)
		sm.playerBody2D.velocity.x = move_toward(sm.playerBody2D.velocity.x, target_velocity, (sm.ACCELERATION * delta) / 2.0)
	else:
		sm.playerBody2D.velocity.x = move_toward(sm.playerBody2D.velocity.x, 0, (sm.ACCELERATION * delta) / 2.0 )
	
	if sm.isJump && sm.coyoteTime < sm.coyoteMax:
		sm.playerBody2D.velocity.y = -sm.MAX_JUMP_VELOCITY
		sm.isJump = false
		sm.coyoteTime = sm.coyoteMax
		print("JUMP")
	elif sm.isJump && sm.isDoubleJump:
		sm.playerBody2D.velocity.y = -sm.MAX_JUMP_VELOCITY
		sm.isDoubleJump = false
		print("Double JUMP")
	
func on_click(tag: String) -> void:
	pass
	
func handleIsJump() -> void:
	
	if Input.is_action_just_pressed("jump"):
		sm.isJump = true
	
	if Input.is_action_just_released("jump"):
		sm.isJump = false
		
func rotateVector(v: Vector2, angle: float) -> Vector2:
	
	var theta := deg_to_rad(angle)
	var cosine := cos(theta)
	var sine := sin(theta)
	
	return Vector2(
		v.x * cosine - v.y * sine,
		v.x * sine + v.y * cosine
	)
