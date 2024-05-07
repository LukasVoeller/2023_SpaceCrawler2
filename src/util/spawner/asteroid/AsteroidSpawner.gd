extends Node2D

#const asteroid = preload("res://src/game/asteroid/Asteroid.tscn")
const AsteroidSmall = preload("res://src/game/asteroid/small/AsteroidSmall.tscn")
const AsteroidMedium = preload("res://src/game/asteroid/medium/AsteroidMedium.tscn")
const AsteroidLarge = preload("res://src/game/asteroid/large/AsteroidLarge.tscn")
const Marker = preload("res://src/util/spawner/asteroid/Marker.tscn")

var rng = RandomNumberGenerator.new()

var device_width
var device_height

var grid_size_x = 8
var grid_size_y = 8
var grid_spacing = 140

var spawner_width = grid_size_x * grid_spacing
var spawner_height = grid_size_y * grid_spacing

var grid_positions = []
var grid_markers = []

signal asteroid_spawned

func _ready():
	randomize()
	rng.randomize()
	device_width = get_viewport_rect().size.x
	device_height = get_viewport_rect().size.y
	$AsteroidTimer.wait_time = Global.asteroid_timer
	$AsteroidTimer.start()

	create_grid_positions()
	create_grid_markers()
	
	init_grid_positions()
	init_grid_marker()


func create_grid_positions():
	for x in grid_size_x:
		var marker_x = Marker.instantiate()
		grid_positions.append([Marker2D.new()])
		
		for y in (grid_size_y-1):
			var marker_y = Marker.instantiate()
			grid_positions[x].append(Marker2D.new())


func create_grid_markers():
	for x in grid_size_x:
		var marker_x = Marker.instantiate()
		grid_markers.append([marker_x])
		add_child(marker_x)
		
		for y in (grid_size_y-1):
			var marker_y = Marker.instantiate()
			grid_markers[x].append(marker_y)
			add_child(marker_y)


func init_grid_positions():
	for x in grid_size_x:
		for y in grid_size_y:
			grid_positions[x][y].position.x = ((x+1)*grid_spacing)
			grid_positions[x][y].position.y = ((y+1)*grid_spacing)


func init_grid_marker():
	for x in grid_size_x:
		for y in grid_size_y:
			grid_markers[x][y].get_node("ColorRect").position.x = grid_positions[x][y].position.x - 60 # - Markersize/2 so the asteroid spawns in the center
			grid_markers[x][y].get_node("ColorRect").position.y = grid_positions[x][y].position.y - 60 # - Markersize/2 so the asteroid spawns in the center
			grid_markers[x][y].get_node("CollisionShape2D").position.x = grid_positions[x][y].position.x
			grid_markers[x][y].get_node("CollisionShape2D").position.y = grid_positions[x][y].position.y


func spawn_asteroid():
	var rand_position_x = randi() % grid_size_x
	var rand_position_y = randi() % grid_size_y
	var velocity = Vector2(randf_range(Global.asteroid_velocity_x_min, Global.asteroid_velocity_x_max), randf_range(Global.asteroid_velocity_y_min, Global.asteroid_velocity_y_max))
	
	if grid_markers[rand_position_x][rand_position_y].overlapping_asteroids != 0:
		return
	else:
		var pos = grid_positions[rand_position_x][rand_position_y]
		var asteroid_i
		
		var asteroid_rng = rng.randi_range(1, 3)
		
		if asteroid_rng == 1:
			asteroid_i = AsteroidSmall.instantiate()
		elif asteroid_rng == 2:
			asteroid_i = AsteroidMedium.instantiate()
		elif asteroid_rng == 3:
			asteroid_i = AsteroidLarge.instantiate()
		
		asteroid_i.position.x = pos.position.x
		asteroid_i.position.y = pos.position.y
		asteroid_i.self_rotate = randf_range(-0.01, 0.01)
		asteroid_i.linear_velocity = velocity
		add_child(asteroid_i)
		emit_signal("asteroid_spawned", asteroid_i)


func _on_AsteroidTimer_timeout():
	spawn_asteroid()
