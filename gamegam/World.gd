extends Node2D

@onready var _player_node : CharacterBody2D = get_tree().get_first_node_in_group("Player")
@onready var _enemy_scene_1 = preload("res://resources/enemy1.tscn")
@onready var _enemy_scene_2 = preload("res://resources/enemy2.tscn")
@onready var _enemy_scene_3 = preload("res://resources/enemy3.tscn")
@onready var _enemy_scene_4 = preload("res://resources/enemy4.tscn")
@onready var _enemy_scene_array = [_enemy_scene_1,_enemy_scene_2,_enemy_scene_3,_enemy_scene_4]
@onready var _player_death_scene = preload("res://resources/player_death_animation.tscn")
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
var _avg_cam_distance:
	get:
		return (get_viewport_rect().size.x + get_viewport_rect().size.y) / 2

func _ready():
	# Start first wave
	_player_node.player_died.connect(_on_player_player_died)
	_enemies_spawns_left = waves.pop_front()
	_spawn_timer.start(1.0)

func _add_enemy():
	var enemy = _enemy_scene_array.pick_random().instantiate()
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
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://win_screen.tscn")

func _on_between_spawns_timeout():
	if _enemies_spawns_left > 0:
		_add_enemy()
		_enemies_spawns_left -= 1
	elif _enemies_left_alive <= 0:
		_wave_timer.start(2.0)
		_spawn_timer.paused = true


func _on_player_player_died():
	var cam : Camera2D = _player_node.camera
	var cam_pos = cam.global_position
	var player_pos = _player_node.global_position
	cam.position_smoothing_enabled = false
	_player_node.remove_child(cam)
	self.add_child(cam)
	cam.global_position = cam_pos
	_player_node.queue_free()
	var deathAni : AnimatedSprite2D = _player_death_scene.instantiate()
	self.add_child(deathAni)
	deathAni.global_position = player_pos + Vector2(7, -29) #hardcoded offset
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://lose_screen.tscn")
