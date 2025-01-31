extends Control

@onready var test_dialogue = load("res://Dialogue/test.dialogue")

func _on_new_button_up() -> void:
	SceneManager.swap_scenes("res://Scenes/gameview.tscn",null,self)

func _on_quit_button_up() -> void:
	get_tree().quit()

func _on_test_dialogue_button_up() -> void:
	DialogueManager.show_dialogue_balloon(test_dialogue)
