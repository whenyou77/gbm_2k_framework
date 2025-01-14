extends Node

@warning_ignore("unused_signal") signal player_allow_move
@warning_ignore("unused_signal") signal npc_next_step

var return_control: bool = true
var not_first_scene: bool = false

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

func dialogue_setup(event_dial: DialogueResource, next_event_step: Callable = Callable(), is_only_event: bool = true):
	# Adds npc to signal (if assigned), then emits signal to disable movement (or something else)
	if (next_event_step): npc_next_step.connect(next_event_step)
	emit_signal("player_allow_move", false)
	emit_signal("npc_next_step", false)
	return_control = is_only_event
	
	DialogueManager.show_dialogue_balloon(event_dial)
	
	#set_active_state(true)

#func handle_dialogue_steps():
	#if _is_writer_done() and Input.is_action_just_pressed("ui_accept"):
		#if _is_dialogue_done():
			#
		#else:
			#dialogue_index += 1 
			#_dialogue_step(dialogue_index) # Next dialogue text
			
func _on_dialogue_ended(_resource):
	#set_active_state(false) # Resets and deactivate dialogue elements
	
	await get_tree().create_timer(0.01).timeout
	emit_signal("npc_next_step", true)
	if return_control:
		emit_signal("player_allow_move", true)
		_disconnect_npc_signals()

#func set_active_state(state: bool):
	#visible = state
	#is_active = state

func _disconnect_npc_signals():
	for i in npc_next_step.get_connections():
		npc_next_step.disconnect(i.callable)
