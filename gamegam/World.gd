extends Node2D

@onready var _player_node : CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var _enemy_scene = preload("res://resources/enemy.tscn")


func _ready():
	var camera : Camera2D = _player_node.camera
	get_viewport_rect().size 



func _on_timer_timeout():
	var enemy = _enemy_scene.instantiate()
	var random_dir_and_distance : Vector2 = Vector2.from_angle(randf()*PI*2) * randf_range(100, 600)
	enemy.global_position = _player_node.global_position + random_dir_and_distance
	self.add_child(enemy)
