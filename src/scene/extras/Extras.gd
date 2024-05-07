extends Node2D

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	$Control.size = screen_size


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://src/scene/options/Options.tscn")
