extends Node2D

@onready var _player_node : CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var _enemy_scene = preload("res://resources/enemy.tscn")
@onready var _wave_timer : Timer = $BetweenWaves
@onready var _spawn_timer : Timer = $BetweenSpawns

## How many waves, how many per wave
@export var waves : Array[int] = [
	1,
	3,
	1
]

var _enemies_spawns_left : int = 0
var _enemies_left_alive : int = 0
var _is_start_next_wave : bool = true
var _current_wave_info

var _avg_cam_distance:
	get:
		return (get_viewport_rect().size.x + get_viewport_rect().size.y) / 2

func _ready():
	# Start first wave
	_enemies_spawns_left = waves.pop_front()
	_spawn_timer.start(1.0)

func _add_enemy():
	var enemy = _enemy_scene.instantiate()
	var random_dir_and_distance : Vector2 = Vector2.from_angle(randf()*PI*2) * randf_range(_avg_cam_distance * 0.8, _avg_cam_distance * 1.2)
	enemy.global_position = _player_node.global_position + random_dir_and_distance
	self.add_child(enemy)
	enemy.just_died.connect(_on_enemy_death)
	_enemies_left_alive += 1

func _on_enemy_death():
	_enemies_left_alive -= 1
	

func _on_between_waves_timeout():
	if waves.size() > 0:
		_enemies_spawns_left = waves.pop_front()
		_spawn_timer.start(1.0)
		_spawn_timer.paused = false
	else:
		print("You win!")

func _on_between_spawns_timeout():
	if _enemies_spawns_left > 0:
		_add_enemy()
		_enemies_spawns_left -= 1
	elif _enemies_left_alive <= 0:
		_wave_timer.start(2.0)
		_spawn_timer.paused = true
