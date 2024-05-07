extends "res://src/game/item/Item.gd"

var tap_count := 1
var timer = Timer.new()

signal inventory_changed

func _ready():
	if upgrade > 0:
		$Upgrade.text = "+" + str(upgrade)
	else:
		$Upgrade.text = ""
	
	$Level.text = str(level)
	if level > Global.spaceship_level:
		$Level.add_theme_color_override("font_color", Color(1,0,0,1))
	
	#print("Instanced ItemDisplay")
	
	timer.one_shot = true
	self.add_child(timer, true)
	timer = get_node('Timer')
	
	#for key in Equipment.in_use:
	#	if Equipment.in_use[key].type == "head":
		#compare_with_equipped(Equipment.in_use[key]."stats")
	
#	for key in Equipment.in_use:
#		if key == type:
#			compare_with_equipped(key, Equipment.in_use[key].stats)
#		if type == "trinket":
#			compare_with_equipped(key, Equipment.in_use["trinket_1"].stats)



func get_copy():
	var copy = load("res://src/game/item/ItemDisplay.tscn").instantiate()
	#func init(_name, rar, lvl, upgr, val, tex_no, equ, _type):
	copy.init(item_name, rarity, level, upgrade, value, texture_no, equipped, type, stats)
	return copy

	
func get_json():
	return ({
		"item_name": item_name,
		"rarity": rarity,
		"level": level,
		"upgrade": upgrade,
		"value": value,
		"texture_no": texture_no,
		"equipped": equipped,
		"type": type,
		"stats": stats,
	})

#func init(_name, _rar, _lvl, _upgr, _val, _tex_no, _equ, _type, _stats):
func init(_name, _rar, _lvl, _upgr, _val, _tex_no, _equ, _type, _stats):
	item_name = _name
	rarity = _rar
	level = _lvl
	upgrade = _upgr
	value = _val
	texture_no = _tex_no
	equipped = _equ
	type = _type
	stats = _stats
	
	if type == "weapon":
		$Texture2D.texture = $TextureLoader.get_texture("weapon", rarity, texture_no)
		$PopupPanel/Popup/Item.texture = $TextureLoader.get_texture("weapon", rarity, texture_no)
		$PopupPanel/Popup/Name.text = item_name
		$PopupPanel/Popup/RarityAndType.text = str(translate_rarity(rarity)) + " " + str(type)
		
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstType.text = "Damage"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirst.text = str(stats.primary_stat_first)
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondType.text = "Attacks per Second"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecond.text = str(1 / stats.primary_stat_second)
		
		if stats.secondary_stat_first != 0:
			$PopupPanel/Popup/SecondaryStats/Bullets/Bullet1.show()
			$PopupPanel/Popup/SecondaryStats/Stats/SecondaryStatFirst.text = "+" + str(stats.secondary_stat_first) + "% Critchance"
		if stats.secondary_stat_second != 0:
			$PopupPanel/Popup/SecondaryStats/Bullets/Bullet2.show()
			$PopupPanel/Popup/SecondaryStats/Stats/SecondaryStatSecond.text = "+" + str(stats.secondary_stat_second) + "% Critdamage"
		if stats.secondary_stat_third == 1:
			$PopupPanel/Popup/SecondaryStats/Bullets/Bullet3.show()
			$PopupPanel/Popup/Sockets/Socket1.show()
			$PopupPanel/Popup/SecondaryStats/Stats/SecondaryStatThird.text = "+" + str(stats.secondary_stat_third) + " Socket"
		if stats.secondary_stat_third == 2:
			$PopupPanel/Popup/SecondaryStats/Bullets/Bullet3.show()
			$PopupPanel/Popup/Sockets/Socket1.show()
			$PopupPanel/Popup/Sockets/Socket2.show()
			$PopupPanel/Popup/SecondaryStats/Stats/SecondaryStatThird.text = "+" + str(stats.secondary_stat_third) + " Sockets"
		
		$PopupPanel/Popup/Footer/Level.text = "Level " + str(level)
		if level > Global.spaceship_level:
			$PopupPanel/Popup/Footer/Level.add_theme_color_override("font_color", Color(1,0,0,1))
			
		$PopupPanel/Popup/Footer/Tier.text = str(texture_no)
	elif type == "shield":
		$Texture2D.texture = $TextureLoader.get_texture("shield", rarity, texture_no)
		
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstType.text = "Armor"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirst.text = str(stats.primary_stat_first)
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondType.text = "Blockchance"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecond.text = str(stats.primary_stat_second)
		
		$PopupPanel/Popup/Item.texture = $TextureLoader.get_texture("shield", rarity, texture_no)
		$PopupPanel/Popup/Name.text = item_name
		$PopupPanel/Popup/Footer/Level.text = "Level " + str(level)
		if level > Global.spaceship_level:
			$PopupPanel/Popup/Footer/Level.add_theme_color_override("font_color", Color(1,0,0,1))
		
		$PopupPanel/Popup/RarityAndType.text = str(translate_rarity(rarity)) + " " + str(type)
		$PopupPanel/Popup/Footer/Tier.text = texture_no
	elif type == "hands":
		$Texture2D.texture = $TextureLoader.get_texture("hands", rarity, texture_no)
		
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstType.text = "Armor"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirst.text = str(stats.primary_stat_first)
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondType.text = "Health"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecond.text = str(stats.primary_stat_second)

		$PopupPanel/Popup/Item.texture = $TextureLoader.get_texture("hands", rarity, texture_no)
		$PopupPanel/Popup/Name.text = item_name
		$PopupPanel/Popup/Footer/Level.text = "Level " + str(level)
		if level > Global.spaceship_level:
			$PopupPanel/Popup/Footer/Level.add_theme_color_override("font_color", Color(1,0,0,1))
		
		$PopupPanel/Popup/RarityAndType.text = str(translate_rarity(rarity)) + " " + str(type)
		$PopupPanel/Popup/Footer/Tier.text = texture_no
	elif type == "head":
		$Texture2D.texture = $TextureLoader.get_texture("head", rarity, texture_no)

		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstType.text = "Armor"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirst.text = str(stats.primary_stat_first)
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondType.text = "Health"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecond.text = str(stats.primary_stat_second)
		
		$PopupPanel/Popup/Item.texture = $TextureLoader.get_texture("head", rarity, texture_no)
		$PopupPanel/Popup/Name.text = item_name
		$PopupPanel/Popup/Footer/Level.text = "Level " + str(level)
		if level > Global.spaceship_level:
			$PopupPanel/Popup/Footer/Level.add_theme_color_override("font_color", Color(1,0,0,1))
		
		$PopupPanel/Popup/RarityAndType.text = str(translate_rarity(rarity)) + " " + str(type)
		$PopupPanel/Popup/Footer/Tier.text = texture_no
	elif type == "chest":
		$Texture2D.texture = $TextureLoader.get_texture("chest", rarity, texture_no)

		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstType.text = "Armor"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirst.text = str(stats.primary_stat_first)
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondType.text = "Health"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecond.text = str(stats.primary_stat_second)

		$PopupPanel/Popup/Item.texture = $TextureLoader.get_texture("chest", rarity, texture_no)
		$PopupPanel/Popup/Name.text = item_name
		$PopupPanel/Popup/Footer/Level.text = "Level " + str(level)
		if level > Global.spaceship_level:
			$PopupPanel/Popup/Footer/Level.add_theme_color_override("font_color", Color(1,0,0,1))
			
		$PopupPanel/Popup/RarityAndType.text = str(translate_rarity(rarity)) + " " + str(type)
		$PopupPanel/Popup/Footer/Tier.text = texture_no
	elif type == "feet":
		
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstType.text = "Armor"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirst.text = str(stats.primary_stat_first)
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondType.text = "Health"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecond.text = str(stats.primary_stat_second)
		
		$Texture2D.texture = $TextureLoader.get_texture("feet", rarity, texture_no)
		$PopupPanel/Popup/Item.texture = $TextureLoader.get_texture("feet", rarity, texture_no)
		$PopupPanel/Popup/Name.text = item_name
		$PopupPanel/Popup/Footer/Level.text = "Level " + str(level)
		if level > Global.spaceship_level:
			$PopupPanel/Popup/Footer/Level.add_theme_color_override("font_color", Color(1,0,0,1))
			
		$PopupPanel/Popup/RarityAndType.text = str(translate_rarity(rarity)) + " " + str(type)
		$PopupPanel/Popup/Footer/Tier.text = texture_no
	elif type == "trinket":
		$Texture2D.texture = $TextureLoader.get_texture("trinket", rarity, texture_no)
		
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstType.text = "Armor"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirst.text = str(stats.primary_stat_first)
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondType.text = "Health"
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecond.text = str(stats.primary_stat_second)
		
		$PopupPanel/Popup/Item.texture = $TextureLoader.get_texture("trinket", rarity, texture_no)
		$PopupPanel/Popup/Name.text = item_name
		$PopupPanel/Popup/Footer/Level.text = "Level " + str(level)
		if level > Global.spaceship_level:
			$PopupPanel/Popup/Footer/Level.add_theme_color_override("font_color", Color(1,0,0,1))
			
		$PopupPanel/Popup/RarityAndType.text = str(translate_rarity(rarity)) + " " + str(type)
		$PopupPanel/Popup/Footer/Tier.text = texture_no

	
	if rarity == 1:
		$Background_1.show()
		$PopupPanel/Popup/RarityAndType.add_theme_color_override("font_color", Color(0.39,0.39,0.39,1))
	if rarity == 2:
		$Background_2.show()
		$PopupPanel/Popup/RarityAndType.add_theme_color_override("font_color", Color(0,0.29,0,1))
	if rarity == 3:
		$Background_3.show()
		$PopupPanel/Popup/RarityAndType.add_theme_color_override("font_color", Color(0,0.2,1,1))
	if rarity == 4:
		$Background_4.show()
		$PopupPanel/Popup/RarityAndType.add_theme_color_override("font_color", Color(0.59,0,1,1))
	if rarity == 5:
		$Background_5.show()
		$PopupPanel/Popup/RarityAndType.add_theme_color_override("font_color", Color(1,0.59,0,1))
			
	if type == "weapon":
		pass
		#$Texture2D.rotation = 45
		#$Texture2D.position.x += 110
		#$Texture2D.position.y -= 40
		#$PopupPanel/Popup/Item.scale = Vector2(0.2, 0.2)
		
	if type == "trinket":
		$Texture2D.scale.x = 0.8
		$Texture2D.scale.y = 0.8
		$Texture2D.position.x = 24
		$Texture2D.position.y = 24


#func _on_touch_screen_button_double_tap():
#	print("Trigger Popup")
#	#print(global_position)
#	#$PopupPanel.position = global_position
#	#$PopupPanel.position.y = global_position.y - 750
#	$PopupPanel.popup_centered()
	
	
	
#	for key in Equipment.in_use:
#		if key == type:
#			compare_with_equipped(key, Equipment.in_use[key].stats)
#		if type == "trinket":
#			compare_with_equipped(key, Equipment.in_use["trinket_1"].stats)

	
#	if get_tree().get_current_scene().get_name() == "Inventory" or get_tree().get_current_scene().get_name() == "Play":
#		print("TAPPED")
#		var tooltip_i = Tooltip.instantiate()
#		add_child(tooltip_i)
#		print(get_children())
		
#		tooltip_i.get_node("Background/VBoxContainer/ItemName").text = str(get_parent().item_name)
#		tooltip_i.get_node("Background/VBoxContainer/Stat1/Stat").text = "Level:"
#		tooltip_i.get_node("Background/VBoxContainer/Stat1/Value").text = str(get_parent().level)
#		tooltip_i.get_node("Background/VBoxContainer/Stat2/Stat").text = "Rarity:"
#		tooltip_i.get_node("Background/VBoxContainer/Stat2/Value").text = str(get_parent().rarity)
#		tooltip_i.get_node("Background/VBoxContainer/Stat3/Stat").text = "Value:"
#		tooltip_i.get_node("Background/VBoxContainer/Stat3/Value").text = str(get_parent().value)
#		tooltip_i.get_node("Background/VBoxContainer/Stat4/Stat").text = "Type:"
#		tooltip_i.get_node("Background/VBoxContainer/Stat4/Value").text = str(get_parent().type)
#		tooltip_i.position = get_global_transform_with_canvas()[2]
#		tooltip_i.position.y -= 420
#		tooltip_i.position.x -= 50
		
#		tooltip_i.popup()


func translate_rarity(rarity):
	if rarity == 1:
		return "Common"
	elif rarity == 2:
		return "Uncommon"
	elif rarity == 3:
		return "Rare"
	elif rarity == 4:
		return "Epic"
	elif rarity == 5:
		return "Legendary"


func _on_popup_panel_focus_exited():
	$PopupPanel.hide()


func _on_texture_2d_gui_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			print("click")
			_tap_counter()


func _tap_counter():
	if timer.time_left == 0:
		timer.start(0.6)
	else:
		tap_count += 1
	
	if tap_count >= 2:
		timer.stop()
		tap_count = 1
		
		print("doubleclick")
		
		if type != "trinket":
			compare_with_equipped(type, Equipment.in_use[type].stats)
		if type == "trinket":
			compare_with_equipped(type, Equipment.in_use["trinket_1"].stats)
		
		$PopupPanel.popup_centered()
		


func _timer_timeout():
	tap_count = 1
	
	
func compare_with_equipped(type, stats_equipped):
	#print("COMPARING ", type, ": ", stats.primary_stat_first, " and ", stats_equipped.primary_stat_first)
	print("COMPARING: ", type, " with: ", stats_equipped)
	var diff_primary_stat_first = stats.primary_stat_first - stats_equipped.primary_stat_first
	var diff_primary_stat_second
	
	if type == "weapon":
		diff_primary_stat_second = (1 / stats.primary_stat_second) - (1 / stats_equipped.primary_stat_second)
	else:
		diff_primary_stat_second = stats.primary_stat_second - stats_equipped.primary_stat_second

	if diff_primary_stat_first < 0:
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstDiff.add_theme_color_override("font_color", Color(1,0,0,1))
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstDiff.text = str(diff_primary_stat_first)
	if diff_primary_stat_first > 0:
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstDiff.add_theme_color_override("font_color", Color(0,1,0,1))
		$PopupPanel/Popup/PrimaryStats/PrimaryStatFirstDiff.text = "+" + str(diff_primary_stat_first)

	if diff_primary_stat_second < 0:
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondDiff.add_theme_color_override("font_color", Color(1,0,0,1))
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondDiff.text = str(diff_primary_stat_second)
	if diff_primary_stat_second > 0:
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondDiff.add_theme_color_override("font_color", Color(0,1,0,1))
		$PopupPanel/Popup/PrimaryStats/PrimaryStatSecondDiff.text = "+" + str(diff_primary_stat_second)

