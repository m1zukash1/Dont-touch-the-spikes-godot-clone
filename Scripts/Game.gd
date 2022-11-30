extends Node2D

var is_game_started:bool = false
var score: int = 0

var last_candy_left : bool = false

func _ready() -> void:
	
	#Connecting signals
	$Bird.connect("died", self, "_on_bird_death")
	$Bird.connect("hit_wall", self, "on_bird_hit_wall")
	
	#Resetting default clear color
	VisualServer.set_default_clear_color(Color("808080"))
	
	#Initializing statistics
	$Menu/VBoxContainer/Candies/Label.set_text(str(GameData.candies))
	match GameData.current_mode:
		GameData.MODE.normal:
			
			$Menu/VBoxContainer/BestScore.set_text("BEST SCORE: " + str(GameData.best_score))
			$Menu/VBoxContainer/GamesPlayed.set_text("GAMES PLAYED: " + str(GameData.games_played))
			
		GameData.MODE.hard:
			switch_to_hard_mode(0.0)
	
	#Hide death screen and show main menu
	$DeathScreen.visible = false
	$Menu.visible = true
	
	$AnimationPlayer.play("BirdIdleMenuAnimation")
	

func on_bird_hit_wall() -> void:
	if $Bird.is_dead:
		return
	score += 1
	$Label.set_text(str(score).pad_zeros(2)) #Setting the score
	Audio.get_node("WallHit").play()
	$Sprites.on_score_change(score) #Calling a method on Sprites.gd (more info in the script)

func _on_bird_death() -> void:
	$DeathScreen/VBoxContainer/ScoreBox/Score.set_text(str(score) + "\n POINTS") #Setting the score stats
	
	match GameData.current_mode:
		GameData.MODE.normal:
			
			if score > GameData.best_score: GameData.best_score = score #Checking if we broke the highscore
			GameData.games_played += 1
			
		GameData.MODE.hard:
			
			if score > GameData.hard_best_score: GameData.hard_best_score = score #Checking if we broke the highscore
			GameData.hard_games_played += 1
			
	
	SaveSystem.save() #Saving everything on death
	
	yield(get_tree().create_timer(0.5),"timeout") #Waiting for half a sec to show the death screen for better feel
	show_death_screen()

func show_death_screen() -> void:
	var tween = create_tween()
	$DeathScreen.modulate.a = 0 #Modulating it to 0 by code for easy debugging in the editor
	
	#Initializing stats for deathscreen
	match GameData.current_mode:
		GameData.MODE.normal:
			
			$DeathScreen/GameName.set_text("DON'T TOUCH\nTHE SPIKES")
			$DeathScreen/VBoxContainer2/Candies/Label.set_text(str(GameData.candies))
			$DeathScreen/VBoxContainer2/BestScore.set_text("BEST SCORE: " + str(GameData.best_score))
			$DeathScreen/VBoxContainer2/GamesPlayed.set_text("GAMES PLAYED: " + str(GameData.games_played))
			
		GameData.MODE.hard:
			$DeathScreen/GameName.set_text("HARD\nMODE")
			$DeathScreen/VBoxContainer2/Candies/Label.set_text(str(GameData.candies))
			$DeathScreen/VBoxContainer2/BestScore.set_text("BEST SCORE: " + str(GameData.hard_best_score))
			$DeathScreen/VBoxContainer2/GamesPlayed.set_text("GAMES PLAYED: " + str(GameData.hard_games_played))
	
	
	tween.tween_property($DeathScreen, "modulate:a", 1.0, 0.75)#Fading in the deathscreen
	$DeathScreen.show()
	tween.play()

func start_game() -> void:
	$AnimationPlayer.stop() #Stopping the bird idle animation (up and down)
	$Bird.velocity.x = $Bird.speed
	$Bird.jump()
	spawn_candy()
	is_game_started = true
	$Label.set_text(str(score).pad_zeros(2)) #Setting the score
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Menu, "modulate:a", 0.0, 0.25)
	tween.play()
	yield(tween,"finished")
	
	match GameData.current_mode:
		GameData.MODE.normal:
			pass
		GameData.MODE.hard:
			var _tween = create_tween()
			_tween.set_loops(INF)
			_tween.tween_property($SpikeSpawner, "position:y", $SpikeSpawner.position.y - 50, 1).set_trans(Tween.TRANS_SINE)
			_tween.tween_property($SpikeSpawner, "position:y", $SpikeSpawner.position.y + 50, 1).set_trans(Tween.TRANS_SINE)
			_tween.play()
	
	$Menu.hide()

func _on_RestartButton_pressed() -> void:
	Audio.get_node("Click").play()
	$AnimationPlayer.play("FadeIn") #Fading in the screen with withe color for smother feel
	yield($AnimationPlayer,"animation_finished") #When the fade in is finished, only then the scene is restarted (It takes less than 1ms to restart the scene on most devices, so its not a problem)
	get_tree().reload_current_scene()

onready var candy = preload("res://Scenes/Candy.tscn")
func spawn_candy():
	if GameData.candies_disabled:
		return
	var c = candy.instance()
	c.position.y = rand_range(180,1000) #Whenever candy is spawned its y position is randomized
	c.connect("collected", self, "on_candy_collected")
	
	if (last_candy_left):
		c.position.x = 96
	else:
		c.position.x = 624
	last_candy_left = !last_candy_left
	call_deferred("add_child",c) #Godot suggests to use call_deffered here instead of the original method of adding a child

func on_candy_collected():
	if $Bird.is_dead:
		return
	GameData.candies += 1
	spawn_candy()

func switch_to_hard_mode(bg_change_speed: float = 0.25):
	$Menu/VBoxContainer/BestScore.set_text("BEST SCORE: " + str(GameData.hard_best_score))
	$Menu/VBoxContainer/GamesPlayed.set_text("GAMES PLAYED: " + str(GameData.hard_games_played))
	$Menu/GameName.set_text("HARD\nMODE")
	$Menu/LeftSideButtons.hide()
	$Menu/RightSideButtons.hide()
	$Menu/BackButton.show()
	
	$Sprites.change_background(Color("E3EFFF"), Color("4C79B1"), bg_change_speed)
		
	
	$Bird.speed = 675
	GameData.current_mode = GameData.MODE.hard
	
func switch_to_normal_mode(bg_change_speed: float = 0.25):
	$Menu/VBoxContainer/BestScore.set_text("BEST SCORE: " + str(GameData.best_score))
	$Menu/VBoxContainer/GamesPlayed.set_text("GAMES PLAYED: " + str(GameData.games_played))
	$Menu/GameName.set_text("DON'T TOUCH\nTHE SPIKES")
	$Menu/LeftSideButtons.show()
	$Menu/RightSideButtons.show()
	$Menu/VBoxContainer.show()
	$Menu/TapToJump.show()
	$Menu/GameName.show()
	$Menu/BackButton.hide()
	$Menu/CandyMenu.hide()
	
	$Sprites.change_background(Color("ebebeb"), Color("808080"), bg_change_speed)
	
	$Bird.speed = 400
	GameData.current_mode = GameData.MODE.normal
	pass
