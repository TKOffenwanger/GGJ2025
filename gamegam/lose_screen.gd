extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$AnimationPlayer.play("RESET")

func end():
	get_tree().paused = true
	$AnimationPlayer.play("Blur")
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_back_to_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
