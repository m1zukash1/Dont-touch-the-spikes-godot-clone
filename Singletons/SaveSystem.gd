extends Node

var save_file = "user://DTTSCSF.savefile" # dont touch the spikes clone save file
var delete_Save_File = true # Used for debugging purposes

func _ready():
	if !delete_Save_File: load_save()
	else: delete_save()

func delete_save():
	DirAccess.remove_absolute(save_file)
	

func save():
	var f = FileAccess.open(save_file, FileAccess.WRITE)

	f.store_var(GameData.games_played)
	f.store_var(GameData.best_score)
	f.store_var(GameData.candies)

	f.store_var(GameData.hard_games_played)
	f.store_var(GameData.hard_best_score)

	f.store_var(GameData.candies_disabled)
	f.store_var(GameData.sound_disabled)



	f.close()

func load_save():
	if FileAccess.file_exists(save_file):
		var f = FileAccess.open(save_file, FileAccess.READ)

		GameData.games_played = f.get_var()
		GameData.best_score = f.get_var()
		GameData.candies = f.get_var()

		GameData.hard_games_played = f.get_var()
		GameData.hard_best_score = f.get_var()

		GameData.candies_disabled = f.get_var()
		GameData.sound_disabled = f.get_var()

		f.close()
