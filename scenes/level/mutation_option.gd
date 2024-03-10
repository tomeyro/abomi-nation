extends ColorRect


var idx: int = 0
var new_part: bool = false
var part_res: PartResource

var _container: Control
var container: Control:
	get:
		if not _container:
			_container = get_node("Container")
		return _container

@onready var progress: ProgressBar = $Progress


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_children().pick_random().visible = true
	self.update_progress(0.0, 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_progress(value: float, target_value: float):
	progress.value = value
	progress.max_value = target_value
	progress.visible = value != 0
