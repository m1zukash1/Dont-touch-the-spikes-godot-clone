extends CPUParticles2D


func _ready() -> void:
	emitting = true
	yield(get_tree().create_timer(lifetime*2),"timeout")
	queue_free()
