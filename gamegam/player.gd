extends CharacterBody2D

signal player_died

@onready var camera = $Camera2D
@onready var grab_bubble = $GrabBubble
@onready var _playerAnimator : AnimationPlayer = $AnimationPlayer
@onready var _personal_bubble : Area2D = $PersonalBubble
@onready var _wahwah : AudioStreamPlayer = $Wahwah
@onready var _brain_blast : AudioStreamPlayer = $BrainBlast

@export var psychic_throw_force : float = 1.0
@export var speed : float = 400.0
@export var skid_time : float  = 1.0
@export var bubble_radius : float  = 1.0:
	set(value):
		bubble_radius = clamp(value, 0.2, 3.0)
		_personal_bubble.scale = Vector2.ONE*bubble_radius
		if bubble_radius < 1:
			_player_die()

var _grabbed_fools : Array = []
var _move_dir : Vector2 = Vector2.ZERO
var _flip_h : bool = false:
	set(value):
		if (_flip_h != value): 
			$Polygons.scale.x *= -1
			$Skeleton2D.scale.x *= -1
		_flip_h = value

func _input(event):
	if event.is_action_released("grab"):
		_wahwah.stop()
		_brain_blast.pitch_scale = randf_range(0.9, 1.1)
		_brain_blast.play()
		for nerd in _grabbed_fools:
			if is_instance_valid(nerd):
				nerd.get_ungrab(psychic_throw_force)
			_grabbed_fools.erase(nerd)

func _physics_process(delta: float) -> void:
#	DEBUG bubble expand contract
	bubble_radius += Input.get_axis("ShrinkBubble","ExpandBubble") * delta
	
	#Bubble physics
	if _personal_bubble.has_overlapping_bodies():
		var num_enemies = _personal_bubble.get_overlapping_bodies().size()
		bubble_radius -= delta * num_enemies / 5
	else:
		bubble_radius += delta
	
	# Grab bubble
	if Input.is_action_pressed("grab"):
		var mouse_direction = (get_global_mouse_position() - global_position).normalized()
		grab_bubble.position = mouse_direction*bubble_radius*210 #Hardcoded pixel radius of current circle
		grab_bubble.scale = bubble_radius * Vector2.ONE
		_wahwah.play()
		var grabbable_fools = grab_bubble.get_overlapping_bodies()
		for grabbable in grabbable_fools:
			if not grabbable.has_method("get_grabbed"):
				print("BROKEN grabbable ", grabbable)
				continue
			grabbable.get_grabbed(grab_bubble)
			_grabbed_fools.append(grabbable)
		#Stop moving
		velocity = velocity.move_toward(Vector2.ZERO, speed*delta/skid_time)
	else:
		
		# Get where we goin
		_move_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
		
		
		if _move_dir != Vector2.ZERO and velocity.length() < 1: # If we wanna move, and we still:
			velocity = _move_dir * speed #Bolt
		elif _move_dir != Vector2.ZERO and _move_dir.dot(velocity) > -0.5: # if we wanna move and we moving that way
			velocity = velocity.lerp(_move_dir * speed, 0.5) #Keep going
		else: #elif velocity.length() > 0 and (_move_dir.length() == 0 or _move_dir.dot(velocity) < 0): # If we moving and wanna stop or go the other way: slow down
			velocity = velocity.move_toward(Vector2.ZERO, speed*delta/skid_time)
	
	_play_animation()
	move_and_slide() #DO THE HUSTLE (Actually do the movement)

func _play_animation():
	if Input.is_action_pressed("grab"): #attack
		_playerAnimator.play("Attack")
	elif velocity.length() > 0: #Walk
		_playerAnimator.play("Walk-loop")
		if _move_dir.x != 0:
			_flip_h = _move_dir.x < 0 #flip sprites if heading left
	else: #Idle
		_playerAnimator.play("Idle-loop")

func _player_die():
	player_died.emit()
	
