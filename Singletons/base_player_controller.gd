class_name PlatformPlayerBase
extends Node

var viewport: Viewport

var isGravity := false
var isYellowOrb := false
var isPinkOrb := false
var isBlueOrb := false
var isGreenOrb := false
var isBlackOrb := false

# Global Constants
const MAX_SPEED: float = 400.0
const MAX_JUMP_VELOCITY: float = 400.0
const ACCELERATION: float = 1500.0
const FRICTION: float = 1200.0
const GRAVITY: float = 1000.0

# Global Misc Interactive Elements
var mouse_pos: Vector2
var mouse_rad: float
var enterDirection: int = 0

# Global Limits
var coyoteMax: float = 200.0 / 1000.0 # Milliseconds
var wall_climb_threshold_x: float = 2.0
var wall_climb_threshold_y: float = 0.0
var wallJumpBuffer: float = 250.0 / 1000.0

# Global Iterators
var coyoteTime: float = 0.0
var wallJumpBufferTime: float = 0.0

# Global State Conditionals
var isJump: bool = false
var isDoubleJump: bool = false
var isClick: bool = false

#const YELLOW_ORB_VELOCITY: float = 400.0
#const PINK_ORB_VELOCITY: float = 300.0
#const BLUE_ORB_VELOCITY: float = 300.0
const BLACK_ORB_VELOCITY_MULT: float = 1.25

var playerBody2D: CharacterBody2D
var velocity: Vector2:
	get: return playerBody2D.velocity
	set(v): playerBody2D.velocity = v

var gravDir: Vector2 = Vector2(0, 1)

var blackOrbActive := false

"""
##############
INITIALIZATION
##############
"""

func handle_tag(tag: String, F: float) -> void:
	match tag:
		"yellow_orb":
			if isYellowOrb:
				yellowOrb(F)
		"pink_orb":
			if isPinkOrb:
				pinkOrb(F)
		"blue_orb":
			if isBlueOrb:
				blueOrb(F)
		"green_orb":
			if isGreenOrb:
				greenOrb(F)
		"black_orb":
			if isBlackOrb:
				blackOrb(F)
		_:
			print("Mismatched Meta Data")

func handleCoyoteTime(delta: float) -> void:
	if !playerBody2D.is_on_floor():
		coyoteTime += delta
		
	else:
		coyoteTime = 0
		
func handleWallJumpBufferTime(delta: float) -> void:
	wallJumpBufferTime += delta
	#print("Wall Jump Buffer: " + str(wallJumpBufferTime))

func yellowOrb(F) -> void:
	if !isYellowOrb: return
	blackOrbActive = false
	velocity = -gravDir * F
	print("Yellow Orb Clicked!")

func pinkOrb(F) -> void:
	if !isPinkOrb: return
	blackOrbActive = false
	velocity = -gravDir * F * (2.0 / 3.0)
	print("Pink Orb Clicked!")

func blueOrb(F) -> void:
	if !isBlueOrb: return
	blackOrbActive = false
	gravDir = rotateVector(gravDir, 180.0)
	velocity = gravDir * F * (3.0 / 4.0)
	print("Blue Orb Clicked!")
	
func greenOrb(F) -> void:
	if !isGreenOrb: return
	blackOrbActive = false
	gravDir = rotateVector(gravDir, 180.0)
	velocity = -gravDir * F
	print("Green Orb Clicked!")

func blackOrb(F) -> void:
	if !isBlackOrb: return
	blackOrbActive = true
	velocity = gravDir * F * BLACK_ORB_VELOCITY_MULT
	print("Black Orb Clicked!")

"""
################
Helper Functions
################
"""

func rotateVector(v: Vector2, angle: float) -> Vector2:
	
	var theta := deg_to_rad(angle)
	var cosine := cos(theta)
	var sine := sin(theta)
	
	return Vector2(
		v.x * cosine - v.y * sine,
		v.x * sine + v.y * cosine
	)
