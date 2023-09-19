extends Area2D

var left : bool = false
var offset : float = -50.0
var enabled : bool = false

func _ready() -> void:
	self.connect("body_entered", Callable(self, "_on_spike_body_entered"))
	var child_rotation : float = deg_to_rad(-90)
	if (left):
		offset = 50.0
		child_rotation = deg_to_rad(90)
	$SpikeSprite.rotation = child_rotation
	$CollisionPolygon2D.rotation = child_rotation

func enable() -> void:
	enabled = true
	var tween = create_tween()
	tween.tween_property(self, "position:x" ,position.x + offset, 0.25) # Move Spike onto the screen
	tween.play()

func disable() -> void:
	if (!enabled):
		return
	enabled = false
	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x - offset, 0.25) # Move Spike off screen
	tween.play()

func _on_spike_body_entered(body) -> void:
	if (body is Bird):
		body.die()
