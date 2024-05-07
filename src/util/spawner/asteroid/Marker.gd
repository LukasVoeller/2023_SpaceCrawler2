extends Area2D

var overlapping_asteroids = 0


func _ready():
	pass


func _on_Node2D_body_entered(body):
	if overlapping_asteroids == 0:
		overlapping_asteroids += 1
		$ColorRect.hide()
		$CollisionShape2D.disabled = true
		#$CollisionShape2D.set_deferred("disabled", true)
	elif overlapping_asteroids > 0:
		overlapping_asteroids += 1


func _on_Node2D_body_exited(body):
	overlapping_asteroids -= 1
	
	if overlapping_asteroids == 0:
		$ColorRect.show()
		$CollisionShape2D.disabled = false
		#$CollisionShape2D.set_deferred("disabled", false)
