extends CPUParticles2D


func _ready() -> void: #Whenever the particle is spawned in to the game. We turn it on, and manually free it after its lifetime is over
	emitting = true
	await get_tree().create_timer(lifetime*2).timeout
	queue_free()
