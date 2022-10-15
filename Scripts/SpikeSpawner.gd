extends Node2D

var loaded_left : bool = false

var rng = RandomNumberGenerator.new()
var diff_range = [2,4] #This defines the minimum and maximum amounts of spikes that can appear on the screen (it is picked randomly based on that range whenever the new spikes need to be spawned)

onready var Spike = preload("res://Scenes/Spike.tscn")

var LeftSpikes : Array = []
var RightSpikes : Array = []

func _ready() -> void:
	randomize()
	init_spikes() #spawning all the spikes to the game node (cba to do it by hand in the editor)
	$"%Bird".connect("hit_wall", self, "_on_bird_hit_wall")

func init_spikes():
	
	var last_spike_y_pos : int = 96
	
	for _i in 11:
		var spike = Spike.instance()
		spike.left = true
		spike.position.x = -28
		spike.position.y = last_spike_y_pos + 88
		last_spike_y_pos = spike.position.y
		LeftSpikes.append(spike)
		add_child(spike)
	
	last_spike_y_pos = 96
	
	for _i in 11:
		var spike = Spike.instance()
		spike.left = false
		spike.position.x = 746
		spike.position.y = last_spike_y_pos + 88
		last_spike_y_pos = spike.position.y
		RightSpikes.append(spike)
		add_child(spike)

func _on_bird_hit_wall():
	
	if $"%Bird".is_dead:
		return
	
	diff_range = score_to_diff_range(get_parent().score)
	
	unload_all_spikes()
	load_spikes(!loaded_left, calc_diff(diff_range))
	loaded_left = !loaded_left

func calc_diff(_range: Array): #Based on the difficulty range, returning one integer which will be the amount of spikes spawned in the next spike loading
	rng.randomize()
	return rng.randi_range(_range[0],_range[1])

func unload_all_spikes(): #Just looping through all the spikes, and calling off method on each spike (Check Sprite.gd)
	for spike in LeftSpikes:
		spike.disable()
	for spike in RightSpikes:
		spike.disable()

func load_spikes(left_side : bool, diff : int):
	if (left_side):
		LeftSpikes.shuffle()
		for i in diff:
			LeftSpikes[i].enable()
	else:
		RightSpikes.shuffle()
		for i in diff:
			RightSpikes[i].enable()

func score_to_diff_range(score : int):
	var range_max = min(int(round(pow(1.055, score - 3)) + 1), 10)
	var range_min = range_max - 1 # Might need to be changed
	return [range_min, range_max]
