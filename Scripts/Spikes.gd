extends Node2D

enum{left, right}
var BirdSide = right

onready var LeftSpike = preload("res://Scenes/LeftSpike.tscn")
onready var RightSpike = preload("res://Scenes/RightSpike.tscn")

var LeftSpikes:Array = []
var RightSpikes:Array = []

func _ready() -> void:
	init_spikes() #spawning all the spikes to the game node (cba to do it by hand in the editor)
	$"%Bird".connect("hit_wall", self, "_on_bird_hit_wall")
	
func init_spikes():
	var last_spike_y_pos:int = 96
	for i in range(11):
		var spike = LeftSpike.instance()
		spike.position.x = -26
		spike.position.y = last_spike_y_pos + 88
		last_spike_y_pos = spike.position.y
		LeftSpikes.append(spike)
		add_child(spike)
		
	last_spike_y_pos = 96
	
	for i in range(11):
		var spike = RightSpike.instance()
		spike.position.x = 746
		spike.position.y = last_spike_y_pos + 88
		last_spike_y_pos = spike.position.y
		RightSpikes.append(spike)
		add_child(spike)
	pass

var diff_range = [2,4] #This defines the minimum and maximum amounts of spikes that can appear on the screen (it is picked randomly based on that range whenever the new spikes need to be spawned)
func _on_bird_hit_wall():
	
	if $"%Bird".is_dead:
		return
		
	#Manully setting the difficulty based on the players score (I could write an algorithm for that, but i see no point in such a simple system)
	
	#This system is kinda unfair and it gets hard really fast
	if get_parent().score == 5:
		diff_range = [3,4]
	if get_parent().score == 10:
		diff_range = [4,5]
	if get_parent().score == 20:
		diff_range = [4,6]
	if get_parent().score == 25:
		diff_range = [4,7]
	if get_parent().score == 30:
		diff_range = [5,7]
	if get_parent().score == 35:
		diff_range = [6,7]
	if get_parent().score == 40:
		diff_range = [7,7]
	if get_parent().score == 50:
		diff_range = [7,8]
		
		
	match BirdSide: #Checking on which side the spikes are currently loaded, then unloading spikes on that side, and loading spikes on the other side.
		left:
			unload_all_spikes()
			load_spikes(right, calc_diff(diff_range))
			BirdSide = right
		right:
			unload_all_spikes()
			load_spikes(left, calc_diff(diff_range))
			BirdSide = left
			
			
var rng = RandomNumberGenerator.new()
func calc_diff(_range: Array): #Based on the difficulty range, returning one integer which will be the amount of spikes spawned in the next spike loading
	rng.randomize()
	return rng.randi_range(_range[0],_range[1])
	pass

func unload_all_spikes(): #Just looping thourgh all the spikes, and calling off method on each spike (Check LeftSpike.gd and RightSpike.gd)
	for spike in LeftSpikes:
		spike.off()
	for spike in RightSpikes:
		spike.off()

func load_spikes(side, diff):
	match side: #Checking on which side we need to load the spikes
		left:
			LeftSpikes.shuffle() #Shuffling the spike array for randomness
			for i in range(diff): 
				LeftSpikes[i].on()
		right:
			RightSpikes.shuffle()
			for i in range(diff):
				RightSpikes[i].on()
	pass
