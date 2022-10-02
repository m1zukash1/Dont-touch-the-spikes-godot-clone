extends Area2D

var is_on:bool = false


func on():
	var tween = create_tween()
	tween.tween_property(self, "position:x",position.x + 50.0,0.25)
	is_on = true
	tween.play()

func off():
	if is_on == false:
		return
	
	var tween = create_tween()
	tween.tween_property(self, "position:x",position.x - 50.0,0.25)
	is_on = false
	tween.play()
	


func _on_LeftSpike_body_entered(body: Node) -> void:
	if body is KinematicBody2D:
		body.die()
