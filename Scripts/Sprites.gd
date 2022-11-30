extends Node2D

onready var GameManager = get_parent()
onready var ScoreText: Label = $"../Label"

func on_score_change(score: int): #This method is called by Game.gd whenever the score changes
	if GameData.current_mode == GameData.MODE.normal:
		match score: #Colors were scanned from the original game
			5:
				change_background(Color("E0EAF0"), Color("63757F"))
			10:
				change_background(Color("F4E8E1"), Color("806A63"))
			15:
				change_background(Color("E8F1DE"), Color("748063"))
			20:
				change_background(Color("E6E1F4"), Color("6B6380"))
			25:
				change_background(Color("727272"), Color("FFFFFF")) 
			#Kinda cba to do all 100 ngl

#Changing the background:
#Creating two tweens, one for property tweening, second for method tweening (one single tween can't tween both methods and properties in parallel)
#change_background function takes two parameters background color, and spike color.
#however, we need to modulate more than 2 nodes, so here are the nodes we modulate
#background color is assigned to: Score Label (the one in the center) and the background sprite
#spike color is assigned to: default_clear_color (default_clear_color is changed because it can be seen on phones with bigger aspect ratios)
#                            GameName label on death screen
#                            BestScore label on death screen
#                            GamesPlayed label on deathscreen
#                            And the whole Spikes node

func change_background(bg: Color, spike: Color, time: float = 0.25):
	var tween = create_tween().set_parallel(true)
	var tween_meth = create_tween().set_parallel(true)
	tween_meth.tween_method(self, "change_label_color", ScoreText.get("custom_colors/font_color"), bg, time, [ScoreText])
	tween_meth.tween_method(self, "change_label_color", $"../Menu/GameName".get("custom_colors/font_color"), spike, time, [$"../Menu/GameName"])
	tween_meth.tween_method(self, "change_label_color", $"../Menu/VBoxContainer/BestScore".get("custom_colors/font_color"), spike, time, [$"../Menu/VBoxContainer/BestScore"])
	tween_meth.tween_method(self, "change_label_color", $"../Menu/VBoxContainer/GamesPlayed".get("custom_colors/font_color"), spike, time, [$"../Menu/VBoxContainer/GamesPlayed"])
	tween_meth.tween_method(self, "change_label_color", $"../DeathScreen/GameName".get("custom_colors/font_color"), spike, time, [$"../DeathScreen/GameName"])
	tween_meth.tween_method(self, "change_label_color", $"../DeathScreen/VBoxContainer2/BestScore".get("custom_colors/font_color"), spike, time, [$"../DeathScreen/VBoxContainer2/BestScore"])
	tween_meth.tween_method(self, "change_label_color", $"../DeathScreen/VBoxContainer2/GamesPlayed".get("custom_colors/font_color"), spike, time, [$"../DeathScreen/VBoxContainer2/GamesPlayed"])	
	tween.tween_property($BackGround, "modulate", bg, time)
	tween.tween_property($Spikes, "modulate", spike, time)
	tween.tween_property($"../SpikeSpawner", "modulate", spike, time)
	pass

func change_default_color(color: Color):
	VisualServer.set_default_clear_color(color)

func change_label_color(color: Color, LabelNode: Label):
	LabelNode.set("custom_colors/font_color", color)
	pass
