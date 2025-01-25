extends CharacterBody2D


@export var speed : float = 400.0
#@export var jump_force : float = 300.0
#@export var gravity : float = 200.0
@export var skid_time : float  = 1.0
#@export var fireball_cooldown_time : float  = 0.33


#@onready var _playerAnimator : AnimatedSprite2D = $PlayerAnimation
#@onready var _fireBall_timer : Timer = $FireballTimer
#var _fireball_scene = preload("res://fireball.tscn")
#var _animator_busy : bool = false
#var _health : int = 3
var _move_dir : Vector2 = Vector2.ZERO

#func _input(event):
	#if event.is_action_pressed("shoot"):
		#_shoot_fireball()
	#elif event.is_action_pressed("restart"):
		#get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	# Get where we goin
	
	_move_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	if _move_dir != Vector2.ZERO and velocity.length() < 1: # If we wanna move, and we still:
		velocity = _move_dir * speed #Bolt
	elif _move_dir != Vector2.ZERO and _move_dir.dot(velocity) > -0.5: # if we wanna move and we moving that way
		velocity = velocity.lerp(_move_dir * speed, 0.5) #Keep going
	#elif velocity.length() > 0 and (_move_dir.length() == 0 or _move_dir.dot(velocity) < 0): # If we moving and wanna stop or go the other way: slow down
		#velocity = velocity.move_toward(Vector2.ZERO, delta*(speed/skid_time))
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta*(speed/skid_time))
	
	# if we're not on the floor: fall, if we are on the floor AND we pressed jump: jump.
	#if not is_on_floor():
		#velocity.y += gravity*delta
	#elif Input.is_action_just_pressed("move_up"):
		#velocity.y = -jump_force
	
	#_play_animation(_move_dir)
	
	move_and_slide() #DO THE HUSTLE (Actually do the movement)
