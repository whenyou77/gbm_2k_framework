extends Node2D

@export var default_music: AudioStreamOggVorbis
@export var default_bg_noise: AudioStreamOggVorbis

func _ready() -> void:
	if not DialogueOw.not_first_scene:
		init_scene()
		_init_dialogue_signal()

func init_scene() -> void:
	name = "World"
	if DialogueOw.not_first_scene:
		var player = get_node_or_null("Pawns/Player")
		if player: 
			$Actor_Grid.set_cell(Vector2i(player.position-Vector2.ONE*8)/16, -1, Vector2i.ZERO)
			player.free()
		Utils.get_node("Player").reparent($Pawns)
		$Pawns/Player.Grid = $Pawns
		
	Utils.change_music(default_music)
	Utils.change_bg_noise(default_bg_noise)
	
	_init_pawn_signals()
	_run_pawn_init_dialogue()

func start_scene():
	_init_dialogue_signal()

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
