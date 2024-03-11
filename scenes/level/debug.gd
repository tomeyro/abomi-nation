extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var logs = []
	logs.append("FPS %s" % int(1.0 / delta))
	logs.append("Enemies %s" % %Enemies.get_child_count())
	logs.append("Speed %s" % (Globals.char.movement_speed if Globals.char else 0.0))
	$Label.text = "\n".join(logs)
