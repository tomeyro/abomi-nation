extends Node2D
class_name Part

var _resource: PartResource
var resource: PartResource:
	get:
		if not _resource:
			_resource = load(scene_file_path.replace("tscn", "tres"))
		return _resource


var _sprite: Sprite2D
var sprite: Sprite2D:
	get:
		if not _sprite:
			for child in get_children():
				if child is Sprite2D:
					_sprite = child
		return _sprite


@onready var body: Body = get_parent().get_parent().get_parent()
@onready var body_owner: Node2D = body.get_parent()
@onready var is_char: bool = body_owner is Char
@onready var char: Char = (body_owner as Char) if is_char else null

var level: int = 1
