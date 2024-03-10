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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
