extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/VBoxContainer/Restart.grab_focus()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_level.tscn")

func _on_back_to_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()
