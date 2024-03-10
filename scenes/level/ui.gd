extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.char:
		_update_life_bar()
		_update_mutation_bar()


func _update_life_bar() -> void:
	%LifeBar.value = Globals.char.life_percentage


func _update_mutation_bar() -> void:
	%MutationBar.value = Globals.char.mutation_percentage
	%MutationBar/Label.text = "%s #%s" % [%MutationBar/Label.text.split(" #", 1)[0], Globals.char.mutation_count]
