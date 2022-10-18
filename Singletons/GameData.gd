extends Node

enum MODE{
	normal,
	hard
	}



var current_mode = MODE.normal

var games_played:int = 0
var best_score: int = 0
var candies: int = 0

var hard_games_played:int = 0
var hard_best_score: int = 0

var candies_disabled:bool = false
var sound_disabled:bool = false
