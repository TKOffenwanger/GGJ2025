extends RigidBody2D

@onready var player_node : CharacterBody2D = get_tree().get_first_node_in_group("Player")

@export var speed : float = 200

var _pulled_toward : Node2D = null
var _rag_dolled : bool = false:
	set(value):
		freeze = not value
		_rag_dolled = value
var _grabbed : bool = false:
	set(value):
		set_collision_layer_value(4, not value)
		_grabbed = value

func _physics_process(delta):
	if _grabbed:
		apply_impulse(_pulled_toward.global_position - global_position)
	elif _rag_dolled:
		if linear_velocity.length() < 1:
			reset_to_normal()
	elif is_instance_valid(player_node):
		var velocity = (player_node.position - position).normalized() * speed
		#position += velocity * del*ta
		move_and_collide(velocity)

func get_grabbed(grab_origin : Node2D):
	_rag_dolled = true
	_grabbed = true
	_pulled_toward = grab_origin

func get_ungrab(force : float):
	linear_velocity = linear_velocity * force
	_grabbed = false

func reset_to_normal():
	_rag_dolled = false
