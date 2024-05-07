extends Asteroid

var hp_base = level * 100
var hp_relative = 0.25
var hp_max
var hp

var damage_base = level * 10
var damage_relative = 0.15
var damage

var exp_give_base = level * 5
var exp_give

var credits_chance = 50
var credits_base = level * 1
var credits_relative = 0.15
var credits


func _ready():
	rng.randomize()
	
	hp = calc_relative(hp_base, hp_relative)
	hp_max = hp
	damage = calc_relative(damage_base, damage_relative)
	exp_give = rng.randi_range(round(exp_give_base * 0.8), round(exp_give_base * 1.2))
	
	var gives_credits = rng.randi_range(1, 100)
	if gives_credits <= credits_chance:
		credits = calc_relative(credits_base, credits_relative)
	else:
		credits = 0
	
	#$Control.position.y += 32
	#$Control.position.x += 32
	#$Control/ProgressBar.size.x = 32
	
	#$Sprite2D.scale = $Sprite2D.scale * 0.5
	#$CollisionShape2D.scale = $CollisionShape2D.scale * 0.5
	#$ExplosionAnimation.scale = $ExplosionAnimation.scale * 0.5
	#$VisibleOnScreenNotifier2D.scale = $VisibleOnScreenNotifier2D.scale * 0.5
	
	#$VisibleOnScreenNotifier2D.position.x = -32
	#$VisibleOnScreenNotifier2D.position.y = -32
	
	$ExplosionAnimation.animation = "explosion_2"
	$ExplosionAnimation.hide()
	
	$Control/ProgressBar.max_value = hp
	$Control/ProgressBar.value = hp


func _process(delta):
	if hp > 0:
		$Sprite2D.rotation += self_rotate
		$VisibleOnScreenNotifier2D.rotation += self_rotate
		$ExplosionAnimation.rotation += self_rotate


func take_projectile_damage(dmg):
	# ChatGPT
	if typeof(dmg) != TYPE_INT or dmg < 1:
		print("Error: Invalid damage amount passed to take_projectile_damage!")
		return
		
	if !invincible:
		$HitEffect.play("flash_white")
		
		hp -= dmg
		
		if hp > 0:
			$Control/ProgressBar.value = hp
		elif hp <= 0:
			#$CollisionShape2D.disabled = true
			$CollisionShape2D.set_deferred("disabled", true)
			$CollisionShape2D.hide()
			$Control/ProgressBar.value = 0
			if alive:
				alive = false
				emit_signal("dead_by_shot")
				explode()


func take_spaceship_damage(body):
	if !invincible:
		$HitEffect.play("flash_white")
		print("Asteroid DMG: ", damage)
		
		hp -= body
		
		if hp > 0:
			$ProgressBar.value = hp
		elif hp <= 0:
			$CollisionShape2D.disabled = true
			$CollisionShape2D.hide()
			emit_signal("dead_by_playercollision")
			print("Dead by player")
			$Control/ProgressBar.value = 0
			explode()
