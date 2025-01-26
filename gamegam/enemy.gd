extends RigidBody2D

@onready var player_node : CharacterBody2D = get_tree().get_first_node_in_group("Player")

@export var speed : float = 200

signal just_died

var _pulled_toward : Node2D = null
var _how_fast_I_was_just_going : float = 0.0
var _rag_dolled : bool = false:
	set(value):
		freeze = not value
		lock_rotation = not value
		_rag_dolled = value
var _grabbed : bool = false:
	set(value):
		set_collision_layer_value(4, not value)
		_grabbed = value

func get_grabbed(grab_origin : Node2D):
	_rag_dolled = true
	_grabbed = true
	_pulled_toward = grab_origin
	apply_torque_impulse(-100 if randf() > 0.5 else 100)

func get_ungrab(force : float):
	linear_velocity = linear_velocity * force
	_grabbed = false

func reset_to_normal():
	_rag_dolled = false
	rotation = 0.0

func _physics_process(delta):
	if _grabbed:
		apply_impulse(_pulled_toward.global_position - global_position)
	elif _rag_dolled:
		if linear_velocity.length() < 10:
			reset_to_normal()
	elif is_instance_valid(player_node):
		var velocity = (player_node.position - position).normalized() * speed
		#position += velocity * del*ta
		move_and_collide(velocity)
	_how_fast_I_was_just_going = linear_velocity.length()

func _on_body_entered(body):
	if body.is_in_group("Player") or (body.is_in_group("Enemy") and body._grabbed):
		return
	if _rag_dolled and _how_fast_I_was_just_going > 5000.0:
		just_died.emit()
		queue_free()
	else:
		_rag_dolled = true
