extends Area2D

signal collected

enum{left, right}

var side = right

@onready var idle_tween = create_tween().set_loops(INF)
func _ready() -> void:
	#Candy animation that loops for ever
	
	#Animation floats the candy up and down
	idle_tween.tween_property(self, "position:y", position.y - 15, 0.5).set_trans(Tween.TRANS_SINE)
	idle_tween.tween_property(self, "position:y", position.y + 15, 0.5).set_trans(Tween.TRANS_SINE)
	idle_tween.play()

func _on_Candy_body_entered(body: Node) -> void:
	if body.name == "Bird" and !body.is_dead:
		emit_signal("collected") #This signal also emits on Game.gd for new candy spawning logic
		disconnect("body_entered", Callable(self, "_on_Candy_body_entered"))
		pass


func _on_Candy_collected() -> void:
	Audio.get_node("Candy").play()
	
	$Particle.show() #Showing the "+1" sign
	var tween = create_tween().set_parallel()
	tween.tween_property($Particle, "position:y", $Particle.position.y - 100, 1) #Floating the "+1" sign up after the candy is collected 
	tween.tween_property($Sprite2D, "modulate:a", 0.0 , 0.5) #Fading out the original candy sprite
	tween.tween_property($Particle, "modulate:a", 0.0 , 1) #Fading out the "+1" sign
	tween.play()
	
	idle_tween.stop() #Stopping the original candy floating animation
	await tween.finished #Whenever we finish the candy collected animation, we manually free the whole candy node.
	queue_free()
