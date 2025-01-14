extends Node

# INTERNAL

var tile_size: Vector2

func _ready() -> void:
	tile_size = Vector2(get_node(Constants.world_path + "Actor_Grid").tile_set.tile_size)

func get_pawn(who: String) -> Node2D:
	return get_node_or_null(NodePath(Constants.world_path + "Pawns/" + who))
	
func get_pawn_ent_dir(entity: Node2D) -> Vector2:
	if entity.name == "Player":
		return entity.cur_direction
	else:
		return entity.animtree.get("parameters/StateMachine/Idle/blend_position")

func get_pawn_dir(who: String) -> Vector2:
	var entity = get_pawn(who)
	if entity: return get_pawn_ent_dir(entity)
	else: return Vector2.ZERO
	
func set_pawn_dir(dir: Vector2i, entity: Node2D):
	entity.set_anim_direction(dir)
	if entity.name == "Player": entity.cur_direction = dir

# DEBUG

func debug(thing):
	print(thing)
	
# DISPLAY

func change_sprite(who: String, to: String):
	var entity = get_pawn(who)
	if entity:
		var sprite = entity.get_node_or_null("Sprite")
		if sprite: sprite.texture = load("res://Graphics/Pawns/"+to)
		else:
			sprite = Sprite2D.new()
			sprite.name = "Sprite"
			sprite.texture = load("res://Graphics/Pawns/"+to)
			entity.add_child(sprite)
	
# MOVEMENT

func move(dir: Vector2i, who: String):
	var entity = get_pawn(who)
	if entity:
		var Grid: Node2D = entity.get_parent()
		var target_position: Vector2i = Grid.request_move(entity, dir)
		if target_position: entity.move_to(target_position)

func turn(dir: Vector2i, who: String):
	var entity = get_pawn(who)
	if entity: set_pawn_dir(dir, entity)
		
func turn_back(who: String):
	var entity = get_pawn(who)
	if entity:
		var dir = get_pawn_ent_dir(entity)
		set_pawn_dir(-dir, entity)
		
func turn_90(who: String):
	var entity = get_pawn(who)
	if entity:
		var dir = get_pawn_ent_dir(entity)
		var angle = deg_to_rad(rad_to_deg(atan2(dir.y,dir.x))+90)
		set_pawn_dir(Vector2i(cos(angle),sin(angle)), entity)

func turn_n90(who: String):
	var entity = get_pawn(who)
	if entity:
		var dir = get_pawn_ent_dir(entity)
		var angle = deg_to_rad(rad_to_deg(atan2(dir.y,dir.x))-90)
		set_pawn_dir(Vector2i(cos(angle),sin(angle)), entity)
		
func look_at_pos(looker_in: String, target: Vector2i):
	var looker = get_pawn(looker_in)
	if looker and target:
		var angle = atan2(target.y-looker.position.y,target.x-looker.position.x)
		set_pawn_dir(Vector2i(cos(angle),sin(angle)), looker)
		
func look_at_pawn(looker_in: String, target_in: String):
	var looker = get_pawn(looker_in)
	var target = get_pawn(target_in)
	if looker and target and looker != target:
		var angle = atan2(target.position.y-looker.position.y,target.position.x-looker.position.x)
		set_pawn_dir(Vector2i(cos(angle),sin(angle)), looker)

func step_forward(who: String):
	var entity = get_pawn(who)
	if entity:
		var Grid: Node2D = entity.get_parent()
		var dir = get_pawn_ent_dir(entity)
		var target_position: Vector2i = Grid.request_move(entity, dir)
		if target_position: entity.move_to(target_position)

func step_back(who: String):
	var entity = get_pawn(who)
	if entity:
		var Grid: Node2D = entity.get_parent()
		var dir = get_pawn_ent_dir(entity)
		var target_position: Vector2i = Grid.request_move(entity, -dir)
		if target_position: entity.move_to(target_position)
		
func step_right(who: String):
	var entity = get_pawn(who)
	if entity:
		var Grid: Node2D = entity.get_parent()
		var dir = get_pawn_ent_dir(entity)
		var angle = deg_to_rad(rad_to_deg(atan2(dir.y,dir.x))+90)
		var target_position: Vector2i = Grid.request_move(entity, Vector2i(cos(angle),sin(angle)))
		if target_position: entity.move_to(target_position)
		
func step_left(who: String):
	var entity = get_pawn(who)
	if entity:
		var Grid: Node2D = entity.get_parent()
		var dir = get_pawn_ent_dir(entity)
		var angle = deg_to_rad(rad_to_deg(atan2(dir.y,dir.x))-90)
		var target_position: Vector2i = Grid.request_move(entity, Vector2i(cos(angle),sin(angle)))
		if target_position: entity.move_to(target_position)

func teleport(where:Vector2i, tween:bool, who: String):
	var entity = get_pawn(who)
	if entity:
		var target_position = where*Vector2i(tile_size)+Vector2i(tile_size/2)
		if tween: entity.move_to(target_position)
		else: entity.global_position = target_position

func transfer(map: String, where: Vector2):
	DialogueOw.not_first_scene = true
	SceneManager.swap_scenes("res://Scenes/Maps/" + map + ".tscn", get_node(Constants.subview_path), get_node(Constants.subview_path).get_child(0))
	await SceneManager.load_complete

func set_speed(speed: float, who: String):
	var entity = get_pawn(who)
	if entity: entity.speed = speed
