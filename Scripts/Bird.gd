extends KinematicBody2D

var speed:float = 400
var jump_speed:float = 700
var gravity:float = 2000

onready var Particle = preload("res://Scenes/Particle.tscn")

var is_dead:bool = false

var velocity: Vector2 = Vector2.ZERO

signal hit_wall
signal died


func _input(event: InputEvent) -> void:
	if is_dead or !get_parent().is_game_started:
		return
	if event is InputEventScreenTouch:
		if event.is_pressed():
			jump()
			
func _process(delta: float) -> void:
	
	if !get_parent().is_game_started:
		return
	
	velocity.y += gravity * delta
	
	if is_on_floor():
		die()
		jump()
	if is_on_ceiling():
		die()
	
	if is_on_wall():
		emit_signal("hit_wall")
		speed = -speed
		velocity.x = speed
		$Sprite.flip_h = !$Sprite.flip_h
		
	if is_dead:
		rotation_degrees += 1000 * delta
		
	move_and_slide(velocity, Vector2.UP)
	
var particle_cooldown: float 
var particle_cooldown_expired:bool = true
var can_spawn_particles:bool = true
func jump():
	velocity.y = -jump_speed
	if !is_dead:
		$Sprite.play("default")
		$Sprite.play("jump")
		Audio.get_node("Jump").play()
	if particle_cooldown_expired and can_spawn_particles:
		var p = Particle.instance()
		add_child(p)
		move_child(p,0)
		particle_cooldown_expired = false
		particle_cooldown = p.lifetime
		yield(get_tree().create_timer(particle_cooldown),"timeout")
		particle_cooldown_expired = true

func die(died_by_ceiling_or_floor: bool = false):
	if is_dead:
		return
	is_dead = true
	Audio.get_node("Death").play()
	emit_signal("died")
	can_spawn_particles = false
	speed *= 3
	velocity.x = speed
	$Sprite.play("death")
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", .0, 0.75)
	tween.play()
