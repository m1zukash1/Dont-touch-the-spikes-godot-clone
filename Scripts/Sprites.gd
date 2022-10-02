extends Node2D

onready var ScoreText: Label = $"../Label"

func on_score_change(score: int):
	match score:
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
	pass

func change_background(bg: Color, spike: Color):
	var tween = create_tween().set_parallel(true)
	var tween_meth = create_tween().set_parallel(true)
	tween_meth.tween_method(self, "change_label_color", ScoreText.get("custom_colors/font_color"), bg, 0.25, [ScoreText])
	tween_meth.tween_method(self, "change_label_color", $"../DeathScreen/GameName".get("custom_colors/font_color"), spike, 0.25, [$"../DeathScreen/GameName"])
	tween_meth.tween_method(self, "change_label_color", $"../DeathScreen/VBoxContainer2/BestScore".get("custom_colors/font_color"), spike, 0.25, [$"../DeathScreen/VBoxContainer2/BestScore"])
	tween_meth.tween_method(self, "change_label_color", $"../DeathScreen/VBoxContainer2/GamesPlayed".get("custom_colors/font_color"), spike, 0.25, [$"../DeathScreen/VBoxContainer2/GamesPlayed"])	
	tween.tween_property($BackGround, "modulate", bg, 0.25)
	tween.tween_property($Spikes, "modulate", spike, 0.25)
	tween.tween_property($"../Spikes", "modulate", spike, 0.25)
	pass


func change_label_color(color: Color, LabelNode: Label):
	LabelNode.set("custom_colors/font_color", color)
	pass 