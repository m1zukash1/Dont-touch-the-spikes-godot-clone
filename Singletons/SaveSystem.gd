extends Node

var save_file = "user://DTTSCSF.savefile" # dont touch the spikes clone save file
var Delete_Save_File = false # Used for debugging purposes
	
func delete_save():
	var f = Directory.new()
	f.remove(save_file)
	pass

func save():
	var f = File.new()
	f.open(save_file,File.WRITE)
	
	f.store_var(GameData.games_played)
	f.store_var(GameData.best_score)
	f.store_var(GameData.candies)
	
	f.store_var(GameData.hard_games_played)
	f.store_var(GameData.hard_best_score)
	
	f.store_var(GameData.candies_disabled)
	f.store_var(GameData.sound_disabled)



	f.close()

func load_save():
	var f = File.new()
	if f.file_exists(save_file):
		f.open(save_file,File.READ)
		
		GameData.games_played = f.get_var()
		GameData.best_score = f.get_var()
		GameData.candies = f.get_var()
		
		GameData.hard_games_played = f.get_var()
		GameData.hard_best_score = f.get_var()
		
		GameData.candies_disabled = f.get_var()
		GameData.sound_disabled = f.get_var()
		
		f.close()
		
func _ready():
	if Delete_Save_File == true:
		delete_save()
	elif Delete_Save_File == false:
		load_save()
