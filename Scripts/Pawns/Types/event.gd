extends Pawn
class_name PawnEvent

@warning_ignore("unused_signal") signal trigger_dialogue

@export var init_dialogue: DialogueResource
@export var dialogue: DialogueResource

func trigger_event(can_proceed: bool = true):
	if can_proceed:
		emit_signal("trigger_dialogue", dialogue)
