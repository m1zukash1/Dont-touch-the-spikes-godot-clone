extends Area2D

signal collected

enum{left, right}

var side = right

onready var idle_tween = create_tween().set_loops(INF)
func _ready() -> void:
	idle_tween.tween_property(self, "position:y", position.y - 15, 0.5).set_trans(Tween.TRANS_SINE)
	idle_tween.tween_property(self, "position:y", position.y + 15, 0.5).set_trans(Tween.TRANS_SINE)
	idle_tween.play()

func _on_Candy_body_entered(body: Node) -> void:
	if body.name == "Bird" and !body.is_dead:
		emit_signal("collected")
		disconnect("body_entered", self, "_on_Candy_body_entered")
		pass


func _on_Candy_collected() -> void:
	Audio.get_node("Candy").play()
	var tween = create_tween().set_parallel()
	tween.tween_property($Particle, "rect_position:y", $Particle.rect_position.y - 100, 1)
	tween.tween_property($Sprite, "modulate:a", 0.0 , 0.5)
	tween.tween_property($Particle, "modulate:a", 0.0 , 1)
	$Particle.show()
	tween.play()
	idle_tween.stop()
	yield(tween,"finished")
	queue_free()
