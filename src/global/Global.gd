extends Node

var rng = RandomNumberGenerator.new()

########## ASTEROID SETTINGS ##########
var asteroid_level = 1
var asteroid_timer = 0.1
var asteroid_velocity_x_min = -50
var asteroid_velocity_x_max = 50
var asteroid_velocity_y_min = 300
var asteroid_velocity_y_max = 500


########## POWERUP SETTINGS ##########
var powerup_timer_range_min = 1
var powerup_timer_range_max = 2


########## BACKGROUND SETTINGS ##########
var star_size_min = 0.5
var star_size_max = 3
var star_speed_min = 500
var star_speed_max = 1500


########## ITEM SETTINGS ##########
var item_drop_chance = 50		# %
var item_rarity_min = 1
var item_rarity_max = 5


########## POWERUP SETTINGS ##########
var powerup_drop_chance = 20	# %


########## WEAPON SETTINGS ##########
var weapon_atk_speed = 0.5
var weapon_projectiles = 5
var weapon_level = 1
var weapon_crit_chance = 5		# %
var weapon_crit_damage = 20		# %


########## STATISTICS ##########
var time_played = 0
var damage_dealt_per_second_average = 0
var damage_dealt_per_second_max = 0
var damage_dealt_per_second = 0
var damage_dealt_total = 0

var spaceship_level = 0


########## DEBUG ##########
var spaceship_collision_disabled = false
var spaceship_hp_max = 100


func _ready():
	print("Global instanced")
	rng.randomize()
