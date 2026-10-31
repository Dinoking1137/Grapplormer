extends CharacterBody2D

var sm: PlatformerStateMachine

func _ready() -> void:
	sm = PlatformerStateMachine.new(self)
	add_child(sm)

	#var detector:= $OrbDetector
	#detector.area_entered.connect(_on_orb_entered)
	#detector.area_exited.connect(_on_orb_exited)
	
func _physics_process(delta: float) -> void:
	sm.update(delta)
	
	#if Input.is_action_just_pressed("grapple"):
		#sm.transition_to("grapple")
	#if Input.is_action_just_pressed("ship"):
		#sm.transition_to("ship")
	
func _on_orb_entered(area: Area2D) -> void:
	var tag = area.get_meta("tag", "")
	
	if tag != "":
		#sm.on_tag_overlap(tag)
		sm.isInOrb = true
		sm.lastOrbTag = tag
		
func _on_orb_exited(area: Area2D) -> void:
	sm.isInOrb = false
