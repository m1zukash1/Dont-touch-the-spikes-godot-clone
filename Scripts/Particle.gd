extends CPUParticles2D


func _ready() -> void: #Whenever the particle is spaned in to the game. We turn it on, and manually free it after its lifetime is over
	emitting = true
	yield(get_tree().create_timer(lifetime*2),"timeout")
	queue_free()
