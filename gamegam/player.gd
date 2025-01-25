extends CharacterBody2D

@onready var bubbleSprite = $BubbleSprite
@onready var camera = $Camera2D
@onready var grab_bubble = $GrabBubble

@export var psychic_throw_force : float = 1.0

@export var speed : float = 400.0
@export var skid_time : float  = 1.0
@export var bubble_radius : float  = 1.0:
	set(value):
		bubble_radius = max(0.2, value)
		bubbleSprite.scale = Vector2.ONE*bubble_radius

var _grabbed_fools : Array = []

#@onready var _playerAnimator : AnimatedSprite2D = $PlayerAnimation
#var _animator_busy : bool = false
#var _health : int = 3
var _move_dir : Vector2 = Vector2.ZERO

func _input(event):
	if event.is_action_released("grab"):
		for nerd in _grabbed_fools:
			nerd.get_ungrab(psychic_throw_force)

func _physics_process(delta: float) -> void:
#	DEBUG bubble expand contract
	bubble_radius += Input.get_axis("ui_cancel", "ui_accept") * delta
	
	# Grab bubble
	if Input.is_action_pressed("grab"):
		var mouse_direction = (get_global_mouse_position() - global_position).normalized()
		grab_bubble.position = mouse_direction*bubble_radius*210 #Hardcoded pixel radius of current circle
		var grabbable_fools = grab_bubble.get_overlapping_bodies()
		for grabbable in grabbable_fools:
			if not grabbable.has_method("get_grabbed"):
				print("BROKEN grabbable ", grabbable)
				continue
			grabbable.get_grabbed(grab_bubble)
			_grabbed_fools.append(grabbable)
	
	# Get where we goin
	_move_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	if _move_dir != Vector2.ZERO and velocity.length() < 1: # If we wanna move, and we still:
		velocity = _move_dir * speed #Bolt
	elif _move_dir != Vector2.ZERO and _move_dir.dot(velocity) > -0.5: # if we wanna move and we moving that way
		velocity = velocity.lerp(_move_dir * speed, 0.5) #Keep going
	else: #elif velocity.length() > 0 and (_move_dir.length() == 0 or _move_dir.dot(velocity) < 0): # If we moving and wanna stop or go the other way: slow down
		velocity = velocity.move_toward(Vector2.ZERO, speed*delta/skid_time)
	
	
	#_play_animation(_move_dir)
	
	move_and_slide() #DO THE HUSTLE (Actually do the movement)
