extends Area2D

var is_on:bool = false


func on():
	var tween = create_tween()
	tween.tween_property(self, "position:x",position.x + 50.0,0.25) #Moving the spike on screen
	is_on = true
	tween.play()

func off():
	if is_on == false: #If the spike is already not present in the game, we do nothing to it
		return
	
	var tween = create_tween()
	tween.tween_property(self, "position:x",position.x - 50.0,0.25) #Moving the spike off screen
	is_on = false
	tween.play()
	


func _on_LeftSpike_body_entered(body: Node) -> void: #If the spike colides with a body, and that body is the bird node. we call a die method on bird
	if body is KinematicBody2D:
		body.die()
