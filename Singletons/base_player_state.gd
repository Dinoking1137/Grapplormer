class_name State
extends RefCounted

var sm: PlatformerStateMachine

const MOVE_SPEED: float = 200.0

func _init(state_machine: PlatformerStateMachine) -> void:
	sm = state_machine
	
func enter() -> void:
	pass

func exit() -> void:
	pass

func apply_gravity(delta: float) -> void:
	if sm.isGravity:
		sm.playerBody2D.velocity += sm.gravDir * sm.GRAVITY * delta
	
func update(_delta: float) -> void:
	pass

func on_click(_tag: String) -> void:
	pass
