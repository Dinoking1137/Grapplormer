class_name GrappleState
extends State

# Tweakable values
const ENTRY_BOOST: float = 1.0
const BOOST_MULT: float = 2.5
const BOOST_VELOCITY: float = 4.0
const DAMPING: float = 0.005
const MAX_DISTANCE: float = 300.0
const MAX_ANGULAR_VELOCITY: float = 4.0

# Angular Velocity
var ω: float = 0.0

# Input Bias
const INPUT_PHASE_SHIFT: float = 1.0
const INPUT_BIAS_RATIO: float = 1.0 / 32.0

# Boost Stuffs
var boosted: bool = false
var boostMax: float = 1000.0 / 1000.0
var boostTime: float = 0.0

# Rope
const ROPE_WIDTH: float = 64.0
var local_rope_width: float

# Polygons
var debug_circle: Polygon2D = null
var rope_rect: Polygon2D = null

func enter() -> void:
	print("Entering Grapple State")
	sm.mouse_pos = sm.playerBody2D.get_global_mouse_position()
	
	seed_omega_from_velocity()
	spawn_debug_circle()
	spawn_rope_rect()
	
	sm.isGravity = true
	sm.isYellowOrb = true
	sm.isPinkOrb = true
	sm.isBlueOrb = true
	sm.isGreenOrb = true
	sm.isBlackOrb = true
	
func exit() -> void:
	print("Exiting Grapple state")
	
func update(delta: float) -> void:
	
	boostTime += delta
	if boostTime >= boostMax: boosted = false
	
	var to_player = sm.playerBody2D.global_position - sm.mouse_pos
	var radius: float = to_player.length()
	
	if radius < 1.0 || radius > MAX_DISTANCE: 
		print("Uh oh")
		print("Radius: " + str(radius))
		forceLetGo()
	
	var r_norm: Vector2 = to_player / radius
	var t_norm = Vector2(-r_norm.y, r_norm.x)
	
	var grav = sm.GRAVITY * sm.gravDir
	var g_tangential: float = grav.dot(t_norm)
	var alpha: float = g_tangential / radius
	
	ω += alpha * delta
	ω *= pow(1.0 - DAMPING, delta * 60.0)
	
	var input_axis := Input.get_axis("left", "right")
	var input_dir = sign(input_axis)
	
	# Ensure Boost is in direction of input press
	if Input.is_action_just_pressed("shift") and not boosted:
		#ω *= BOOST_MULT
		ω = BOOST_VELOCITY
		ω *= -input_dir if sign(ω) > 0 else input_dir
		boosted = true
		boostTime = 0.0
		print("ω: " + str(ω))
	else:
		var input_bias: float = INPUT_PHASE_SHIFT * INPUT_BIAS_RATIO
		#ω += -input_dir * input_bias if sign(ω) > 0 else input_dir * input_bias
		ω += -input_bias * input_dir
	
	ω = clampf(ω, -MAX_ANGULAR_VELOCITY, MAX_ANGULAR_VELOCITY)
	sm.playerBody2D.velocity = t_norm * (ω * radius)
	update_rope_rect(to_player, radius)
	handleLetGo()
	
func on_click(tag: String) -> void:
	pass

func spawn_rope_rect() -> void:
	rope_rect = Polygon2D.new()
	rope_rect.color = Color.html("#888888FF")
	rope_rect.z_index = -10
	sm.add_child(rope_rect)

func update_rope_rect(arm: Vector2, L: float) -> void:
	if not is_instance_valid(rope_rect): return
	
	rope_rect.global_position = sm.mouse_pos
	var hw: float = local_rope_width * 0.5
	rope_rect.polygon = PackedVector2Array([
		Vector2(-hw, 0.0),
		Vector2(hw, 0.0),
		Vector2(hw, L),
		Vector2(-hw, L),
	])
	
	rope_rect.rotation = arm.angle() - PI/2.0

func seed_omega_from_velocity() -> void:
	
	var to_player = sm.playerBody2D.global_position - sm.mouse_pos
	var radius: float = to_player.length()
	
	local_rope_width = ROPE_WIDTH / sqrt(radius)
	
	if radius > 1.0:
		var r_norm: Vector2 = to_player / radius
		var t_norm = Vector2(-r_norm.y, r_norm.x)
		ω = sm.playerBody2D.velocity.dot(t_norm) * ENTRY_BOOST / radius
	
func handleLetGo() -> void:
	
	if Input.is_action_just_released("click"):
		forceLetGo()

func forceLetGo() -> void:
	
	sm.remove_child(debug_circle)
	sm.remove_child(rope_rect)
	
	boosted = false
	if sm.playerBody2D.is_on_floor():
		sm.transition_to("grounded")
	else:
		sm.transition_to("air")

func apply_gravity(delta: float) -> void:
	pass

func createCircle(poly: Polygon2D, radius: float, edgeCount: int):
	
	var points = PackedVector2Array()
	
	for i in range(edgeCount):
		var angle = (2 * PI / edgeCount) * i
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		points.append(Vector2(x, y))
		
	poly.polygon = points

func spawn_debug_circle() -> void:
	
	debug_circle = Polygon2D.new()
	createCircle(debug_circle, 16, 8)
	debug_circle.color = Color.html("#FF0088FF")
	debug_circle.global_position = sm.mouse_pos
	sm.add_child(debug_circle)

func rotateVector(v: Vector2, angle: float) -> Vector2:
	
	var theta := deg_to_rad(angle)
	var cosine := cos(theta)
	var sine := sin(theta)
	
	return Vector2(
		v.x * cosine - v.y * sine,
		v.x * sine + v.y * cosine
	)
