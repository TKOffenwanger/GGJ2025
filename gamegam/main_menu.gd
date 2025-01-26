extends Control

@onready var SceneTransitionAnimation = $SceneTransitionAnimation/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_game_pressed() -> void:
	get_node(SceneTransitionAnimation).show()
	SceneTransitionAnimation.play("fade_in")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://main_level.tscn")


func _on_exit_game_pressed() -> void:
	get_tree().quit()
