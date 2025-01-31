extends PawnEvent

@export var map: String
@export var where: Vector2i
@export var dir: Vector2i
@export var transition: String = "fade_to_black"
@export var sfx: String

func trigger_event(can_proceed: bool = true):
	var string = "~ main\n\ndo Utils.transfer(\"%s\", Vector2%v, \"%s\", Vector2%v)" % [map, where, transition, dir]
	var resource: DialogueResource = DialogueManager.create_resource_from_text(string)
	if not sfx.is_empty(): Utils.play_global_sfx(sfx)
	emit_signal("trigger_dialogue", resource)
