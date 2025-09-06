extends Control
@onready var continue_button : Control = $PanelContainer/VBoxContainer/Continue
func _ready():
	hide()
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide()

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show()
	continue_button.grab_focus()
	
func testEsc():
	if Input.is_action_just_pressed("Esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("Esc") and get_tree().paused == true:
		resume()
	

func _on_continue_pressed() -> void:
	resume()


func _on_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_return_to_title_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_quit_game_pressed() -> void:
	get_tree().quit()

func _process(_delta):
	testEsc()
