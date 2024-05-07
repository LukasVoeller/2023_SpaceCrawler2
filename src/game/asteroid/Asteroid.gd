extends RigidBody2D

class_name Asteroid

signal dead_by_shot
signal dead_by_playercollision

#const ExpText = preload("res://src/util/text/exp_text/ExpText.tscn")
const DamageText = preload("res://src/util/text/damage_text/DamageText.tscn")
const HitParticles = preload("res://src/util/particle/AsteroidHitParticles.tscn")
const ExplosionParticles = preload("res://src/util/particle/AsteroidExplosionParticles.tscn")

var rng = RandomNumberGenerator.new()
var level = Global.asteroid_level
var self_rotate = 0
var overlaps_marker = false
var spawned_powerup = false
var spawned_item = false
var invincible = false
var alive = true


func _ready():
	rng.randomize()


func calc_relative(base, relative):
	var minimun = base - base*relative
	var maximum = base + base*relative
	return rng.randi_range(minimun, maximum)


func show_damage(dmg_amount, is_crit, _pos):
	var dmg_text = DamageText.instantiate()
	dmg_text.text = str(dot_seperate(dmg_amount))
	add_child(dmg_text)
	dmg_text.display(is_crit)


func show_particles(pos, angle):
	var pos_asteroid = self.get_global_transform_with_canvas()
	var pos_diff_x = pos_asteroid[2].x - pos.x
	var pos_diff_y = pos_asteroid[2].y - pos.y
	
	var hit_particles_i = HitParticles.instantiate()
	hit_particles_i.emitting = true
	hit_particles_i.one_shot = true
	hit_particles_i.position.x -= pos_diff_x
	hit_particles_i.position.y -= pos_diff_y + 50
	hit_particles_i.process_material.direction.x = angle.x
	hit_particles_i.process_material.direction.y = angle.y
	
	add_child(hit_particles_i)


func explode():
	var explosion_particles_i = ExplosionParticles.instantiate()
	explosion_particles_i.emitting = true
	explosion_particles_i.one_shot = true
	add_child(explosion_particles_i)
	
	$Control/Level.hide()
	$Control/ProgressBar.hide()
	$Sprite2D.hide()
	$ExplosionAnimation.show()
	$ExplosionAnimation.play()


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_ExplosionAnimation_animation_finished():
	self.queue_free()


func dot_seperate(number):
	var string = str(number)
	var mod = string.length() % 3
	var res = ""
	
	for i in range(0, string.length()):
		if i != 0 && i % 3 == mod:
			res += "."
		res += string[i]
	
	return res
