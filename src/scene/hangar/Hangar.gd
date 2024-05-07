extends Node2D

var screen_size

var rng = RandomNumberGenerator.new()

func _ready():
	screen_size = get_viewport_rect().size
	$Control.size = screen_size
	#load_game()
	
	$Control/StatsBar/Values/Played.text = str(Global.time_played)
	
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	if not save_game:
		print("COLDSTART")
		#var spaceship = load("res://src/game/spaceship/Spaceship.tscn").instantiate()
		var player = load("res://src/game/player/Player.tscn").instantiate()
		#add_child(spaceship)
		add_child(player)
		#$Spaceship.movement_enabled = false
		#$Spaceship.global_position = Vector2(125, 300)
		#$Control/StatsBar/Labels/Level/Label.text = "Level:"
		#$Control/StatsBar/V/Level/Value.text = str($Spaceship.level)
		#$Control/StatsBar/V/Credits/Label.text = "Credits:"
		#$Control/StatsBar/V/Credits/Value.text = dot_seperate($Player.credits)
		#$Control/StatsBar/V/HPMax/Label.text = "Max HP:"
		#$Control/StatsBar/V/HPMax/Value.text = str($Spaceship.hp_max)
		#$Control/StatsBar/V/DPSAvg/Label.text = "Avg DPS:"
		#$Control/StatsBar/V/DPSAvg/Value.text = str($Player.dps)
		#$Control/StatsBar/V/DPSMax/Label.text = "Max DPS:"
		#$Control/StatsBar/V/DPSMax/Value.text = str($Player.max_dps)
	else:
		pass
		#$Spaceship.movement_enabled = false
		#$Spaceship.global_position = Vector2(125, 300)
		#$Control/StatsBar/V/Level/Label.text = "Level:"
		#$Control/StatsBar/V/Level/Value.text = str($Spaceship.level)
		#$Control/StatsBar/V/Credits/Label.text = "Credits:"
		#$Control/StatsBar/V/Credits/Value.text = dot_seperate($Player.credits)
		#$Control/StatsBar/V/HPMax/Label.text = "Max HP:"
		#$Control/StatsBar/V/HPMax/Value.text = str($Spaceship.hp_max)
		#$Control/StatsBar/V/DPSAvg/Label.text = "Avg DPS:"
		#$Control/StatsBar/V/DPSAvg/Value.text = str($Player.dps)
		#$Control/StatsBar/V/DPSMax/Label.text = "Max DPS:"
		#$Control/StatsBar/V/DPSMax/Value.text = str($Player.max_dps)

	$AnimationTimer.start()
	#$ColorRect.set_size(Vector2(device_width - 50, device_height/2))
	#$ColorRect.set_global_position(Vector2(25, device_height/2 - 25))
	
	#$BackButton.set_global_position(Vector2(25, 25))
	#$BackButton.size.x = 60
	#$BackButton.size.y = 60

#func _on_AnimationTimer_timeout():
#	change_animation()

#func change_animation():
#	var i = rng.randi_range(1, 3)
#
#	if i == 1:
#		$Spaceship.get_node("SpaceshipSprite").animation = "spaceship_left"
#	if i == 2:
#		$Spaceship.get_node("SpaceshipSprite").animation = "spaceship_center"
#	if i == 3:
#		$Spaceship.get_node("SpaceshipSprite").animation = "spaceship_right"



func load_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	if not save_game:
		return # Error! We don't have a save to load.

	while save_game.get_position() < save_game.get_length():
		# Get the saved dictionary from the next line in the save file
		var test_json_conv = JSON.new()
		test_json_conv.parse(save_game.get_line())
		var node_data = test_json_conv.get_data()

		#print(node_data)
		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instantiate()
		add_child(new_object)
		#get_node(node_data["parent"]).add_child(new_object)
	
		#print("LOAD GAME: ", new_object)
	
		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent":
				continue
			new_object.set(i, node_data[i])

	save_game.close()



func dot_seperate(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += "."
		res += string[i]

	return res


func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://src/scene/menu/Menu.tscn")


func _on_inventroy_button_pressed():
	get_tree().change_scene_to_file("res://src/scene/inventory/Inventory.tscn")


func _on_quests_button_pressed():
	get_tree().change_scene_to_file("res://src/scene/quests/Quests.tscn")


func _on_skills_button_pressed():
	get_tree().change_scene_to_file("res://src/scene/skills/Skills.tscn")
