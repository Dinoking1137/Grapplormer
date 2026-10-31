class_name PlatformerStateMachine
extends PlatformPlayerBase

var current_state: State
var states: Dictionary = {}

var isInOrb := false
var lastOrbTag: String

func _init(player_body: CharacterBody2D) -> void:
	
	playerBody2D = player_body
	viewport = player_body.get_viewport()
	
	states = {
		"grapple": GrappleState.new(self),
		"attack_grapple": AttackGrappleState.new(self),
		"air": AirState.new(self),
		"grounded": GroundedState.new(self),
		"wall_climb": WallClimbState.new(self),
		#"ship": ShipState.new(self),
	}
	
	transition_to("grounded")
	
func transition_to(state_name: String) -> void:
	
	if current_state:
		current_state.exit()
	
	isGravity = true
	isYellowOrb = false
	isPinkOrb = false
	isBlueOrb = false
	isGreenOrb = false
	isBlackOrb = false
	
	current_state = states[state_name]
	current_state.enter()
	
func update(delta: float) -> void:
	if current_state:
		#current_state.handle_movement()
		playerBody2D.move_and_slide()
		handleCoyoteTime(delta)
		handleWallJumpBufferTime(delta)
		current_state.apply_gravity(delta)
		current_state.update(delta)
	
func on_orb_jump(tag: String, F: float):
	handle_tag(tag, F)
	#current_state.on_click(tag)
	
#func on_tag_overlap(tag: String):
	#isInOrb = true
	##handle_tag(tag)
