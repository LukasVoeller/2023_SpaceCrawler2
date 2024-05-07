extends Node2D

class_name Player

var player_name
var credits = 0
var max_dps = 0
var inventory = []
var collected = []

func _ready():
	print("Instanced Player")
	load_inventory()

#func init(_name, _rar, _lvl, _upgr, _val, _tex_no, _equ, _type, _stats):
func _on_Item_collected(item):
	collected.append({
		"item_name": item.item_name,
		"rarity": item.rarity,
		"level": item.level,
		"upgrade": item.upgrade,
		"value": item.value,
		"texture_no": item.texture_no,
		"equipped": item.equipped,
		"type": item.type,
		"stats": item.stats
	})
	#print("Collecte ITEM with tex_no: ", item.texture_no)
	item.queue_free()
	
	
func save_inventory():
	var save_game = FileAccess.open("user://saveinventory.save", FileAccess.WRITE)

	# Save inventory
	for i in inventory.size():
		var data = inventory[i]
		save_game.store_line(JSON.new().stringify(data))

	# Add collected
	for i in collected.size():
		var data = collected[i]
		save_game.store_line(JSON.new().stringify(data))
	save_game.close()


func load_inventory():
	var save_game = FileAccess.open("user://saveinventory.save", FileAccess.READ)
	if not save_game:
		return # Error! We don't have a save to load.

	while save_game.get_position() < save_game.get_length():
		var test_json_conv = JSON.new()
		test_json_conv.parse(save_game.get_line())
		var node_data = test_json_conv.get_data()

		inventory.append(node_data)

	save_game.close()
	

func save():
	save_inventory()
	
	var save_dict = {
		"filename" : "res://src/game/player/Player.tscn",
		"credits" : credits,
		"max_dps" : max_dps
	}
	return save_dict
