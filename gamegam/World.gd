extends Node2D

@onready var _player_node : CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var _enemy_scene = preload("res://resources/enemy.tscn")
@onready var _timer : Timer = $Timer

@export var enemy_spawn_time : float = 1.0
@export var timer_enabled : bool = true


func _ready():
	_timer.paused = not timer_enabled
	_timer.wait_time = enemy_spawn_time
	#var camera : Camera2D = _player_node.camera
	#get_viewport_rect().size 

func change_enemy_spawn_timer(enable_timer : bool, time_between_spawns : float):
	_timer.start(time_between_spawns)
	enemy_spawn_time = time_between_spawns
	_timer.paused = not enable_timer
	timer_enabled = enable_timer

func _on_timer_timeout():
	var enemy = _enemy_scene.instantiate()
	var random_dir_and_distance : Vector2 = Vector2.from_angle(randf()*PI*2) * randf_range(100, 600)
	enemy.global_position = _player_node.global_position + random_dir_and_distance
	self.add_child(enemy)
