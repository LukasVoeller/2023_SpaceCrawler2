extends Node2D

const Spaceship = preload("res://src/game/spaceship/Spaceship.tscn")
#const Asteroid = preload("res://src/game/asteroid/Asteroid.tscn")
const Powerup = preload("res://src/game/powerup/Powerup.tscn")
const Player = preload("res://src/game/player/Player.tscn")
const ExpText = preload("res://src/util/text/exp_text/ExpText.tscn")


var rng = RandomNumberGenerator.new()

var max_int = 9223372036854775807
var asteroid_counter = 0
var asteroid_clear_cap = 50
var clear_reward = 1000
var dps_timer_elapsed_time = 0

var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	$Control.size = screen_size
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	rng.randomize()
	
	dps_timer_elapsed_time = 0
	Global.damage_dealt_per_second_average = 0
	Global.damage_dealt_per_second_max = 0
	Global.damage_dealt_per_second = 0
	Global.damage_dealt_total = 0
	
	asteroid_counter = 0
	$DPSTimer.start()
	$UpdateSpawnrateTimer.start()
	#$PowerupTimer.start()
	
	load_game()
	connect_listeners()
	game_start()
	$Control/SkillBar/ExpBar/ExpBar.value = $Spaceship.exp_current


func connect_listeners():
	$Spaceship.connect("hit",Callable(self,"_on_Spaceship_hit"))
	$Spaceship.connect("dead",Callable(self,"_on_Spaceship_dead"))
	$Spaceship.connect("hp_changed",Callable(self,"_on_Spaceship_hp_changed"))


func init_ui():
	$Control.z_index = 20
	
	$AsteroidSpawner.position.y -= 1300
	#$AsteroidSpawner.position.x -= 25
	
	$Control/SkillBar/ExpBar/Level/LevelText.text = str($Spaceship.level)
	$Control/SkillBar/ExpBar/ExpBar.max_value = $Spaceship.exp_max
	$Control/SkillBar/ExpBar/ExpBar.value = $Spaceship.exp_current
	$Control/SkillBar/ExpBar/ExpText.text = str($Spaceship.exp_current) + " / " + str($Spaceship.exp_max)
	
	$Control/Gold/Label.text = dot_seperate($Player.credits)
	#$Control/DPSProgress/DPSText.text = str(Global.damage_dealt_per_second_average)
	$Control/SkillBar/HPBar/HPBarText.text = str(dot_seperate($Spaceship.hp_current)) + " / " + str(dot_seperate(Global.spaceship_hp_max))
	$Control/SkillBar/HPBar.max_value = Global.spaceship_hp_max
	$Control/SkillBar/HPBar.value = $Spaceship.hp_current
	$Control/LevelProgress/ProgressBar.value = asteroid_counter
	$Control/LevelProgress/Min.text = str(asteroid_counter)
	$Control/LevelProgress/ProgressBar.max_value = asteroid_clear_cap
	$Control/LevelProgress/Max.text = str(asteroid_clear_cap)
	
	
	#$Control/YouDead.hide()


func game_start():
	init_ui()
	$PlayedTimer.start()
	$Spaceship.start($SpaceshipStartPosition.position)
	#$PowerupTimer.start()
	$AsteroidSpawner/AsteroidTimer.start()
	
	
func scale_asteroid(asteroid, scale):
	asteroid.get_node("Sprite2D").scale.x *= scale
	asteroid.get_node("Sprite2D").scale.y *= scale
	asteroid.get_node("CollisionPolygon2D").scale.x *= scale
	asteroid.get_node("CollisionPolygon2D").scale.y *= scale
	asteroid.get_node("ExplosionAnimation").scale.x *= 2
	asteroid.get_node("ExplosionAnimation").scale.y *= 2


func _on_Spaceship_hp_changed():
	$Control/SkillBar/HPBar/HPBarText.text = str(dot_seperate($Spaceship.hp_current)) + " / " + str(dot_seperate(Global.spaceship_hp_max))
	$Control/SkillBar/HPBar.value = $Spaceship.hp_current


func _on_Spaceship_hit():
	pass


func _on_Asteroid_dead_by_shot(asteroid):
	asteroid_counter += 1
	
	var item_chance_calc = rng.randi_range(1, 100)
	print("CALC: ", item_chance_calc)
	if item_chance_calc <= Global.item_drop_chance && !asteroid.spawned_item:
		if asteroid.get_global_transform_with_canvas()[2].y > 400:
			#if asteroid.get_global_transform_with_canvas()[2].x > (screen_size.x - 50) && asteroid.get_global_transform_with_canvas()[2].x < 50:
			$ItemSpawner.spawn_item($Player, $Spaceship.level, asteroid)
			asteroid.spawned_item = true
			
	var powerup_chance_calc = rng.randi_range(1, 100)
	if powerup_chance_calc <= Global.powerup_drop_chance && !asteroid.spawned_item:
		if asteroid.get_global_transform_with_canvas()[2].y > 400:
			#if asteroid.get_global_transform_with_canvas()[2].x > (screen_size.x - 50) && asteroid.get_global_transform_with_canvas()[2].x < 50:
			spawn_powerup(asteroid)
			asteroid.spawned_item = true

	$Control/LevelProgress/ProgressBar.value = asteroid_counter
	$Control/LevelProgress/Min.text = str(asteroid_counter)
	$Player.credits += asteroid.credits
	$Control/Gold/Label.text = dot_seperate($Player.credits)
	#$Control/LevelCreditsDPS.text = "C: " + dot_seperate($Player.credits)
	
	if asteroid_counter == asteroid_clear_cap:
		level_cleared()
	else:
		#asteroid.show_exp(asteroid.exp_give)
		#var exp = round(asteroid.exp_give * 0.9)
		$Spaceship.exp_current += asteroid.exp_give
		$Control/ExpText.text = "+" + str(asteroid.exp_give) + " EXP"
		
#		if asteroid.level+4 <= $Spaceship.level:
#			var exp = round(asteroid.exp_give * 0.6)
#			$Spaceship.exp_current += exp
#			$Control/ExpText.text = "+" + str(exp) + " EXP"
#		elif asteroid.level+3 == $Spaceship.level:
#			var exp = round(asteroid.exp_give * 0.7)
#			$Spaceship.exp_current += exp
#			$Control/ExpText.text = "+" + str(exp) + " EXP"
#		elif asteroid.level+2 == $Spaceship.level:
#			var exp = round(asteroid.exp_give * 0.8)
#			$Spaceship.exp_current += exp
#			$Control/ExpText.text = "+" + str(exp) + " EXP"
#		elif asteroid.level+4 == $Spaceship.level:
#			var exp = round(asteroid.exp_give * 0.9)
#			$Spaceship.exp_current += exp
#			$Control/ExpText.text = "+" + str(exp) + " EXP"
#		elif asteroid.level == $Spaceship.level:
#			var exp = round(asteroid.exp_give * 1)
#			$Spaceship.exp_current += exp
#			$Control/ExpText.text = "+" + str(exp) + " EXP"
#		elif asteroid.level-1 == $Spaceship.level:
#			var exp = round(asteroid.exp_give * 1.15)
#			$Spaceship.exp_current += exp
#			$Control/ExpText.text = "+" + str(exp) + " EXP"
#		elif asteroid.level-2 == $Spaceship.level:
#			var exp = round(asteroid.exp_give * 1.2)
#			$Spaceship.exp_current += exp
#			$Control/ExpText.text = "+" + str(exp) + " EXP"
#		elif asteroid.level-3 == $Spaceship.level:
#			var exp = round(asteroid.exp_give * 1.25)
#			$Spaceship.exp_current += exp
#			$Control/ExpText.text = "+" + str(exp) + " EXP"
#		elif asteroid.level-3 > $Spaceship.level:
#			var diff = asteroid.level - $Spaceship.level
#
#			if diff >= 10 && diff < 20:
#				var exp = round(asteroid.exp_give * 3)
#				$Spaceship.exp_current += exp
#				$Control/ExpText.text = "+" + str(exp) + " EXP"
#			elif diff >= 20 && diff < 30:
#				var exp = round(asteroid.exp_give * 4)
#				$Spaceship.exp_current += exp
#				$Control/ExpText.text = "+" + str(exp) + " EXP"
#			elif diff >= 30 && diff < 40:
#				var exp = round(asteroid.exp_give * 5)
#				$Spaceship.exp_current += exp
#				$Control/ExpText.text = "+" + str(exp) + " EXP"
#			elif diff >= 40 && diff < 60:
#				var exp = round(asteroid.exp_give * 7)
#				$Spaceship.exp_current += exp
#				$Control/ExpText.text = "+" + str(exp) + " EXP"

		
		$Control/SkillBar/ExpBar/ExpBar.value = $Spaceship.exp_current
		$Control/SkillBar/ExpBar/ExpText.text = str($Spaceship.exp_current) + " / " + str($Spaceship.exp_max)
		
		if $Spaceship.exp_current >= $Spaceship.exp_max:
			show_level_up()
			$Spaceship.level_up()
			$Control/SkillBar/HPBar.value = $Spaceship.hp_current
			$Control/SkillBar/HPBar/HPBarText.text = str(dot_seperate($Spaceship.hp_current)) + " / " + str(dot_seperate(Global.spaceship_hp_max))
			$Control/SkillBar/ExpBar/ExpBar.max_value = $Spaceship.exp_max
			$Control/SkillBar/ExpBar/ExpBar.value = $Spaceship.exp_current
			$Control/SkillBar/ExpBar/ExpText.text = str($Spaceship.exp_current) + " / " + str($Spaceship.exp_max)
			$Control/SkillBar/ExpBar/Level/LevelText.text = str($Spaceship.level)
			
			
	var asteroid_clear_cap_part = asteroid_clear_cap / 5
	
	if asteroid_counter == asteroid_clear_cap_part * 2:
		$AsteroidSpawner/AsteroidTimer.wait_time = $AsteroidSpawner/AsteroidTimer.wait_time / 2
	elif asteroid_counter == asteroid_clear_cap_part * 4:
		$AsteroidSpawner/AsteroidTimer.wait_time = $AsteroidSpawner/AsteroidTimer.wait_time / 2


func show_level_up():
	$Control/LevelUp.show()
	$LevelUpTimer.start()
	


func spawn_powerup(asteroid):
	var powerup_i = Powerup.instantiate()
	var powerup_spawn_location = asteroid.get_global_transform_with_canvas()
	powerup_i.position.x = powerup_spawn_location[2].x
	powerup_i.position.y = powerup_spawn_location[2].y
	powerup_i.linear_velocity = asteroid.linear_velocity
	add_child(powerup_i)


func _on_Spaceship_dead():
	$PlayedTimer.stop()
	if $Player.max_dps < Global.damage_dealt_per_second_max:
		$Player.max_dps = Global.damage_dealt_per_second_max
	#$Control/Abilities.hide()
	$DPSTimer.stop()
	#$PowerupTimer.stop()
	$Control/LevelFailed.show()
	$Spaceship.queue_free()
	$Control/SkillBar/MenuButton.disabled = true
	save_game()


func level_cleared():
	explode_all_asteroids()
	$Spaceship.game_paused = true
	$Control/SkillBar/MenuButton.disabled = true
	$Spaceship.level_cleard = true
	$AsteroidSpawner/AsteroidTimer.stop()
	$PlayedTimer.stop()
	$DPSTimer.stop()
	if $Player.max_dps < Global.damage_dealt_per_second_max:
		$Player.max_dps = Global.damage_dealt_per_second_max
	
	await get_tree().create_timer(3).timeout
	$Control/LevelCleared.show()
	#$Control/SkillBar.hide()
	$Spaceship.queue_free()
	save_game()
	

func _on_Ability_1_pressed():
	pass
	print("1")
#	if $Spaceship.auto_shoot:
#		$Spaceship.auto_shoot = false
#	else:
#		$Spaceship.auto_shoot = true


func _on_Ability_2_pressed():
	pass
	print("2")
#	if $Spaceship.get_node("SpaceshipCollision").disabled:
#		$Spaceship.get_node("SpaceshipCollision").disabled = false
#	else:
#		$Spaceship.get_node("SpaceshipCollision").disabled = true


func _on_Ability_3_pressed():
	pass
	print("3")
#	$Spaceship.weapon.damage_base -= 5


func save_game():
	var spaceship_save = FileAccess.open("user://spaceship.save", FileAccess.WRITE)
	#var spaceship_node = get_tree().get_nodes_in_group("SaveSpaceship")
	var spaceship_data = $Spaceship.save()
	spaceship_save.store_line(JSON.new().stringify(spaceship_data))
	spaceship_save.close()

	var player_save = FileAccess.open("user://player.save", FileAccess.WRITE)
	#var player_node = get_tree().get_nodes_in_group("SavePlayer")
	var player_data = $Player.save()
	player_save.store_line(JSON.new().stringify(player_data))
	player_save.close()


func load_game():
	load_player()
	load_spaceship()


func load_player():
	var save_player = FileAccess.open("user://player.save", FileAccess.READ)
	
	var test_json_conv = JSON.new()
	test_json_conv.parse(save_player.get_line())
	var node_data = test_json_conv.get_data()

	var new_object = load(node_data["filename"]).instantiate()
	add_child(new_object)

	for i in node_data.keys():
		if i == "filename":
			continue
		new_object.set(i, node_data[i])

	save_player.close()


func load_spaceship():
	var save_spaceship = FileAccess.open("user://spaceship.save", FileAccess.READ)
	
	var test_json_conv = JSON.new()
	test_json_conv.parse(save_spaceship.get_line())
	var node_data = test_json_conv.get_data()

	var new_object = load(node_data["filename"]).instantiate()
	add_child(new_object)

	for i in node_data.keys():
		if i == "filename":
			continue
		new_object.set(i, node_data[i])

	save_spaceship.close()


func _on_DPSTimer_timeout():		
	#$DPSProgress/DPSText.text = str(Global.damage_dealt_per_second)
	#$DPSProgress/DPSText.text = str(Global.damage_dealt_per_second_average)
	
	$Control/DPSMeter/DPS.text = str(dot_seperate(Global.damage_dealt_per_second))
	$Control/DPSMeter/DPSAvg.text = str(dot_seperate(Global.damage_dealt_per_second_average))
	$Control/DPSMeter/DpsMax.text = str(dot_seperate(Global.damage_dealt_per_second_max))
	
	dps_timer_elapsed_time += 1
	
	if  (max_int - Global.damage_dealt_per_second) <= Global.damage_dealt_total:
		print("INTEGER OVERFLOW!")
		Global.damage_dealt_total = 0
	else:
		Global.damage_dealt_total += Global.damage_dealt_per_second
		
	Global.damage_dealt_per_second = 0
	Global.damage_dealt_per_second_average = Global.damage_dealt_total / dps_timer_elapsed_time

	#$Control/DPSProgress.value = Global.damage_dealt_per_second_average


func _on_UpdateSpawnrateTimer_timeout():
	pass
	
	#print("Spantimer")
	
#	var new_wait_time = float(1 / (1 + pow((asteroid_counter/100), 2)))
#
#	if asteroid_counter > 0:
#		var dif_ast = asteroid_counter / 100.0
#		var sep_dif_ast = snapped(dif_ast, 0.01)
#		var pow_dif_ast = pow(sep_dif_ast, 2.0)
#		var result = 1.0 / (1.0 + pow_dif_ast)
#		var sep_result = snapped(result, 0.01)
#		$AsteroidSpawner/AsteroidTimer.wait_time = sep_result - 0.5




func dot_seperate(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""

	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += "."
		res += string[i]

	return res



func _on_PlayedTimer_timeout():
	Global.time_played += 1


func _on_pause_resume_button_pressed():
	for child in $Spaceship/Weapon.get_children():
		if child is Projectile:
			child.game_paused = false
	
	get_tree().paused = false
	$PlayedTimer.start()
	$Spaceship.show()
	$Background.show()
	$Background.get_node("StarTimer").start()
	$Spaceship.get_node("SpaceshipSprite").play()
	$Spaceship.movement_enabled = true
	$Spaceship.game_paused = false
	$AsteroidSpawner/AsteroidTimer.start()
	$DPSTimer.start()
	$Control/Pause.hide()


func explode_all_asteroids():
	var on_screen_asteroids = []
	
	for n in $AsteroidSpawner.get_children():
		if n is Asteroid:
			on_screen_asteroids.append(n)
	
	while on_screen_asteroids.size() > 0:
		var rand_asteroid = rng.randi_range(0, on_screen_asteroids.size()-1)
		
		if (is_instance_valid(on_screen_asteroids[rand_asteroid])):
			on_screen_asteroids[rand_asteroid].explode()
		
		on_screen_asteroids.remove_at(rand_asteroid)
		await get_tree().create_timer(0.03).timeout


func _on_pause_menu_button_pressed():
	#save_game()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/scene/menu/Menu.tscn")


func _on_level_cleared_menu_button_pressed():
	get_tree().change_scene_to_file("res://src/scene/menu/Menu.tscn")


func _on_level_cleared_failed_button_pressed():
	get_tree().change_scene_to_file("res://src/scene/menu/Menu.tscn")


func _on_level_up_timer_timeout():
	$Control/LevelUp.hide()


func _on_asteroid_spawner_asteroid_spawned(asteroid):
	asteroid.connect("dead_by_shot", Callable(self,"_on_Asteroid_dead_by_shot").bind(asteroid))


func _on_menu_button_pressed():
	if $Player.max_dps < Global.damage_dealt_per_second_max:
		$Player.max_dps = Global.damage_dealt_per_second_max
		
	for child in $Spaceship/Weapon.get_children():
		if child is Projectile:
			child.game_paused = true

	get_tree().paused = true
	$PlayedTimer.stop()
	$Spaceship.hide()
	$Background.hide()
	$Background.get_node("StarTimer").stop()
	$Spaceship.get_node("SpaceshipSprite").stop()
	$Spaceship.movement_enabled = false
	$Spaceship.game_paused = true
	$Spaceship/WeaponTimer.stop()
	$AsteroidSpawner/AsteroidTimer.stop()
	$DPSTimer.stop()
	$Control/Pause.show()
	save_game()
