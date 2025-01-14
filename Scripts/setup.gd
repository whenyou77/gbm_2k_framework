extends Node2D

@export var player: Node2D

func _ready() -> void:
	_init_dialogue_signal()
	_init_pawn_signals()
	await SceneManager.load_complete
	name = "World"
	_run_pawn_init_dialogue()

func _init_dialogue_signal():
	# Setup signal to activate/deactivate player movement
	if $Pawns/Player: DialogueOw.player_allow_move.connect($Pawns/Player.set_talking)

func _init_pawn_signals():
	# Setup signals to trigger dialogue
	for i in $Pawns.get_children():
		if ("dialogue" in i):
			i.trigger_dialogue.connect(DialogueOw.dialogue_setup)

func _run_pawn_init_dialogue():
	for i in $Pawns.get_children():
		if ("init_dialogue" in i):
			if i.init_dialogue: DialogueManager.show_dialogue_balloon(i.init_dialogue)
