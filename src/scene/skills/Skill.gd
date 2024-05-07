extends Control

signal selected

var offensive_background = preload("res://assets/ui/darkpixelrpg/decors/patterns/pattern_h_cross.png")
var defensive_background = preload("res://assets/ui/darkpixelrpg/decors/patterns/pattern_h_diamond.png")
var ultimative_backgraound = preload("res://assets/ui/darkpixelrpg/decors/patterns/pattern_h_skull.png")

var title
var info_text = "Lorem ipsum"
var level
var level_max
var active = false
var type

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func init(_title, _type, _active):
	title = _title
	type = _type
	active = _active
	#$Label.text = _title
	
	if type == "offensive":
		#$Background.texture = offensive_background
		info_text = "offensive"
	elif type == "defensive":
		#$Background.texture = defensive_background
		info_text = "defensive"
	elif type == "ultimative":
		#$Background.texture = ultimative_backgraound
		info_text = "ultimative"
		


func _on_texture_button_pressed():
	#var v_box = get_parent()
	#v_box.add_theme_constant_override("separation", 702)
	#$Background.show()
	emit_signal("selected")
