extends Node2D

const Skill = preload("res://src/scene/skills/Skill.tscn")
const SkillBlank = preload("res://src/scene/skills/SkillBlank.tscn")

var rng = RandomNumberGenerator.new()
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	$Control.size = screen_size
	
	rng.randomize()
	generate_skills()
	
	get_node("Control/Background/Offensive").get_v_scroll_bar().custom_minimum_size.x = 75


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func init(_title, objective_val, objective_goal):
func generate_skills():
	# Row 1#
	var skill1 = Skill.instantiate()
	var skill2 = Skill.instantiate()
	var skill_blank_1 = SkillBlank.instantiate()
	var skill_blank_2 = SkillBlank.instantiate()
	
	skill1.init("Skill1", "offensive", false)
	skill1.connect("selected", Callable(self, "_on_Skill_selected").bind(skill1))
	skill1.get_node("Icon").set_texture(load("res://assets/skills/icons/offensive/skill_claw_A.png"))
	
	skill2.init("Skill2", "offensive", false)
	skill2.connect("selected", Callable(self, "_on_Skill_selected").bind(skill2))
	skill2.get_node("Icon").set_texture(load("res://assets/skills/icons/offensive/skill_magic_dagger_A.png"))
	
	var h_box_container = HBoxContainer.new()
	h_box_container.add_theme_constant_override("separation", 200)
	h_box_container.add_child(skill_blank_1)
	h_box_container.add_child(skill1)
	h_box_container.add_child(skill2)
	h_box_container.add_child(skill_blank_2)
	$Control/Background/Offensive/VBoxContainer.add_child(h_box_container)


func _on_Skill_selected(skill):
	$Control/Details/SkillTitle.text = skill.title
	$Control/Details/SkillInfo.text = skill.info_text


func _on_offensive_pressed():
	$Control/Background/Offensive.show()
	$Control/Background/Defensive.hide()
	$Control/Background/Ultimative.hide()


func _on_defensive_pressed():
	$Control/Background/Offensive.hide()
	$Control/Background/Defensive.show()
	$Control/Background/Ultimative.hide()


func _on_ultimative_pressed():
	$Control/Background/Offensive.hide()
	$Control/Background/Defensive.hide()
	$Control/Background/Ultimative.show()


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://src/scene/hangar/Hangar.tscn")
