extends Node2D

var is_game_started:bool = false
var score: int = 14




func _ready() -> void:
	randomize()
	$Bird.connect("died", self, "_on_bird_death")
	$Bird.connect("hit_wall", self, "on_bird_hit_wall")
	$Menu/VBoxContainer/BestScore.set_text("BEST SCORE: " + str(GameData.best_score))
	$Menu/VBoxContainer/GamesPlayed.set_text("GAMES PLAYED: " + str(GameData.games_played))
	$Menu/VBoxContainer/Candies/Label.set_text(str(GameData.candies))
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if !is_game_started:
				start_game()

func on_bird_hit_wall(): 
	if $Bird.is_dead:
		return
	score += 1
	$Label.set_text(str(score).pad_zeros(2))
	Audio.get_node("WallHit").play()
	$Sprites.on_score_change(score)

func _on_bird_death():
	$DeathScreen/VBoxContainer/ScoreBox/Score.set_text(str(score) + "\n POINTS")
	if score > GameData.best_score: GameData.best_score = score
	GameData.games_played += 1
	SaveSystem.save()
	yield(get_tree().create_timer(0.5),"timeout")
	show_death_screen()
	pass

func show_death_screen():
	var tween = create_tween()
	$DeathScreen.modulate.a = 0
	
	$DeathScreen/VBoxContainer2/Candies/Label.set_text(str(GameData.candies))
	$DeathScreen/VBoxContainer2/BestScore.set_text("BEST SCORE: " + str(GameData.best_score))
	$DeathScreen/VBoxContainer2/GamesPlayed.set_text("GAMES PLAYED: " + str(GameData.games_played))
	
	tween.tween_property($DeathScreen, "modulate:a", 1.0, 0.75)
	$DeathScreen.show()
	tween.play()
	pass

func start_game():
	$AnimationPlayer.stop()
	$Bird.velocity.x = $Bird.speed
	$Bird.jump()
	spawn_candy()
	is_game_started = true
	$Label.set_text(str(score).pad_zeros(2))
	$Menu.hide()
	pass


func _on_RestartButton_pressed() -> void:
	Audio.get_node("Click").play()
	$AnimationPlayer.play("FadeIn")
	yield($AnimationPlayer,"animation_finished")
	get_tree().reload_current_scene()


enum{left, right}
onready var candy = preload("res://Scenes/Candy.tscn")
onready var candy_side = left
func spawn_candy():
	var c = candy.instance()
	c.position.y = rand_range(180,1000)
	c.connect("collected", self, "on_candy_collected")
	
	match candy_side:
		left:
			c.position.x = 96
			candy_side = right
		right:
			c.position.x = 624
			candy_side = left
			
	call_deferred("add_child",c)
	

func on_candy_collected():
	if $Bird.is_dead:
		return
	GameData.candies += 1
	spawn_candy()
