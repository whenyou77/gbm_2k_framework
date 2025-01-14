extends Pawn

@warning_ignore("unused_signal") signal trigger_dialogue

@export var dialogue: DialogueResource

func trigger_event(_direction: Vector2i):
	# Set it to null to indicate that the actor is immobile
	emit_signal("trigger_dialogue", dialogue)
