extends Node


var parts = {}

var char: Char

var window_size: Vector2
var window_scale: Vector2


func _ready() -> void:
	_update_window_size()
	_load_parts()


func _process(delta: float) -> void:
	_update_window_size()


func _load_parts() -> void:
	for part in ["heads", "bodies", "arms", "legs"]:
		var part_dir = "res://scenes/parts/" + part
		var res := DirAccess.open(part_dir)
		parts[part] = []
		for file in res.get_files():
			if not file.begins_with("vampire") and not file.begins_with("human"):
				continue
			if file.ends_with(".tres"):
				parts[part].append(load(part_dir + "/" + file))


func _update_window_size() -> void:
	window_size = get_viewport().get_visible_rect().size
	window_scale = window_size / Vector2(
		ProjectSettings.get("display/window/size/viewport_height"),
		ProjectSettings.get("display/window/size/viewport_width")
	)


func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")
