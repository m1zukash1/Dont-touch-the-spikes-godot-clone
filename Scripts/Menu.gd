extends Control

onready var GameManager : Node2D = get_parent()
var can_start_game : bool = true

func _on_Menu_gui_input(event: InputEvent) -> void: # Starting game from here thereby it wouldn't start game on menu button presses
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if !GameManager.is_game_started and can_start_game:
				GameManager.start_game()


func _ready() -> void:
	if GameData.candies_disabled: $CandyMenu/VBoxContainer/DisableCandies.set_text("ENABLE CANDIES")
	else: $CandyMenu/VBoxContainer/DisableCandies.set_text("DISABLE CANDIES")
	
	if GameData.sound_disabled: $CandyMenu/VBoxContainer/DisableSound.set_text("ENABLE SOUND")
	else: $CandyMenu/VBoxContainer/DisableSound.set_text("DISABLE SOUND")

func _on_HardModeButton_pressed() -> void:
	Audio.get_node("Click").play()
	GameManager.switch_to_hard_mode()

func _on_BackButton_pressed() -> void:
	Audio.get_node("Click").play()
	GameManager.switch_to_normal_mode()
	can_start_game = true

func _on_CandyButton_pressed() -> void:
	Audio.get_node("Click").play()
	$GameName.hide()
	$TapToJump.hide()
	$VBoxContainer.hide()
	$LeftSideButtons.hide()
	$RightSideButtons.hide()
	$BackButton.show()
	$CandyMenu.show()
	GameManager.get_node("Sprites").change_background(Color("F4E8E1"), Color("806A63"))
	can_start_game = false


func _on_DisableCandies_pressed() -> void:
	Audio.get_node("Click").play()
	GameData.candies_disabled = !GameData.candies_disabled
	if GameData.candies_disabled: $CandyMenu/VBoxContainer/DisableCandies.set_text("ENABLE CANDIES")
	else: $CandyMenu/VBoxContainer/DisableCandies.set_text("DISABLE CANDIES")


func _on_DisableSound_pressed() -> void:
	Audio.get_node("Click").play()
	GameData.sound_disabled = !GameData.sound_disabled
	if GameData.sound_disabled: 
		$CandyMenu/VBoxContainer/DisableSound.set_text("ENABLE SOUND")
		AudioServer.set_bus_mute(0, true)
	else: 
		$CandyMenu/VBoxContainer/DisableSound.set_text("DISABLE SOUND")
		AudioServer.set_bus_mute(0, false)
	
