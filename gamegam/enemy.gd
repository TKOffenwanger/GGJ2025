extends RigidBody2D

@onready var player_node : CharacterBody2D = get_tree().get_first_node_in_group("Player")

@export var speed : float = 200

func _physics_process(delta):
	if is_instance_valid(player_node):
		var velocity = (player_node.position - position).normalized() * speed
		position += velocity * delta
		#move_and_collide(velocity)
