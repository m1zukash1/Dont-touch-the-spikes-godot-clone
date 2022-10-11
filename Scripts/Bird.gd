extends KinematicBody2D
class_name Bird

var speed : float = 400
var jump_speed : float = 700
var gravity : float = 2000

onready var Particle = preload("res://Scenes/Particle.tscn")

var is_dead :bool = false

var velocity: Vector2 = Vector2.ZERO

var particle_cooldown : float 
var particle_cooldown_expired : bool = true
var can_spawn_particles : bool = true

signal hit_wall
signal died

func _input(event: InputEvent) -> void:
	#Basically: do not perform jump, if the bird is dead, or the game hasn't started
	if is_dead or !get_parent().is_game_started:
		return
		
	if event is InputEventScreenTouch:
		if event.is_pressed():
			jump()
			
func _process(delta: float) -> void:
	
	if !get_parent().is_game_started:
		return
	
	velocity.y += gravity * delta
	
	#Checking for death conditions, if the bird died to the floor spikes it looks better if it performs a jump, but if the bird died to ceiling spikes, it looks better if it just falls asap
	if is_on_floor():
		die()
		jump()
	
	if is_on_ceiling():
		die()
	
	if is_on_wall(): #if the wall is hit, change flying direction
		emit_signal("hit_wall")
		speed = -speed
		velocity.x = speed
		$Sprite.flip_h = !$Sprite.flip_h #flips the spride to opposite direction
		
	if is_dead: #improvised death animation
		rotation_degrees += 1000 * delta
		
	move_and_slide(velocity, Vector2.UP)
	
	
func jump() -> void:
	
	velocity.y = -jump_speed #Performing the jump
	
	if !is_dead: 
		$Sprite.play("default") #Godot does some weird stuff, if the sprite anim isn't defaulted before playing jump anim
		$Sprite.play("jump")
		Audio.get_node("Jump").play()
		
	if particle_cooldown_expired and can_spawn_particles:
		var p = Particle.instance()
		add_child(p)
		move_child(p,0) #Moving the particle node to the front of the screen, so it would not appear behind the background or bird
		particle_cooldown_expired = false
		particle_cooldown = p.lifetime
		yield(get_tree().create_timer(particle_cooldown),"timeout") #Introducing a cooldown before being able to spawn new particles so the screen wouldn't get flooded with new particles if the player spams the screen with jumps
		particle_cooldown_expired = true

func die() -> void:
	if is_dead:
		return
		
	is_dead = true
	Audio.get_node("Death").play()
	emit_signal("died")
	can_spawn_particles = false
	speed *= 3 # improvised death anim
	velocity.x = speed
	$Sprite.play("death")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", .0, 0.75) #fading out the bird sprite
	tween.play()
