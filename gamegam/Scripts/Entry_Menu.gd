extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	$PanelContainer/VBoxContainer/Continue.grab_focus()
	
func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide()
	
func _on_continue_pressed() -> void:
	resume()
