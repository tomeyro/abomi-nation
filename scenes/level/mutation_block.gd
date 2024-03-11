extends ColorRect

signal selected(part: PartResource)
signal hover(part: PartResource, action: String)
signal hover_ended(part: PartResource)

@onready var top_row: HBoxContainer = $top_row
@onready var bottom_row: HBoxContainer = $bottom_row

var part_name: String
var part_res: PartResource
@onready var part_node: Control = $Part
var new_part_res: PartResource = preload("res://scenes/parts/new_part.tres")
@export var new_part_sprite: Texture2D

var selecting: Control
var selecting_duration: float = 0.0
var selecting_duration_target: float = .5

var char: Char


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var idx := 0
	mouse_entered.connect(_on_option_mouse_entered.bind(self))
	mouse_exited.connect(_on_option_mouse_exited.bind(self))
	for option in (top_row.get_children() + bottom_row.get_children()):
		option.idx = idx
		idx += 1
		option.mouse_entered.connect(_on_option_mouse_entered.bind(option))
		option.mouse_exited.connect(_on_option_mouse_exited.bind(option))
		option.gui_input.connect(_on_option_gui_input.bind(option))


func randomize_option(char: Char, not_part: PartResource = null):
	self.char = char
	part_name = Globals.parts.keys().pick_random()
	part_name = "heads"

	for child in part_node.get_children():
		child.queue_free()
	part_res = Globals.parts[part_name].pick_random()

	if part_res == not_part:
		return randomize_option(char, not_part)

	var part: Part = part_res.tscn.instantiate()
	var part_sprite: Sprite2D = part.sprite.duplicate()
	part_sprite.position = Vector2.ZERO
	part_node.add_child(part_sprite)
	part.queue_free()

	var reached_empty = false
	for option in (top_row.get_children() + bottom_row.get_children()):
		for child in option.container.get_children():
			child.queue_free()
		if not reached_empty and char.body[part_name + "_count"] >= (option.idx + 1):
			option.new_part = true
			option.visible = true
			option.part_res = null
			var current_part: Part = char.body.get_part(part_name, option.idx)
			if current_part:
				option.part_res = char.body[part_name][option.idx]
				var current_part_sprite: Sprite2D = current_part.sprite.duplicate()
				current_part_sprite.position = Vector2.ZERO
				current_part_sprite.scale = Vector2.ONE * (0.5 if part_name in ["bodies", "heads"] else 0.75)
				option.container.add_child(current_part_sprite)
				option.new_part = false
			if not current_part:
				reached_empty = true
				var sprite = Sprite2D.new()
				sprite.texture = new_part_sprite
				sprite.scale = Vector2.ONE * 0.25
				option.container.add_child(sprite)
		else:
			option.visible = false

	selecting = null
	selecting_duration = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if selecting:
		selecting_duration += delta
		selecting.update_progress(selecting_duration, selecting_duration_target)
		if selecting_duration >= selecting_duration_target:
			if selecting.new_part:
				char.body[part_name].append(part_res)
			else:
				if char.body[part_name][selecting.idx] == part_res:
					char.body.level_up_part(part_name, selecting.idx)
				else:
					char.body[part_name][selecting.idx] = part_res
			selecting.update_progress(0.0, selecting_duration_target)
			selecting = null
			selected.emit(part_res)
	else:
		selecting_duration = 0.0


func _on_option_mouse_entered(option):
	var action = "none"
	if option != self:
		if not option.part_res:
			action = "new"
		elif option.part_res == part_res:
			action = "upgrade"
		else:
			action = "replace"
		option.container.get_child(0).scale += Vector2.ONE * .2
	hover.emit(option.part_res if option.part_res else new_part_res, action)


func _on_option_mouse_exited(option):
	hover_ended.emit(option.part_res if option.part_res else new_part_res)
	if option and option != self and option.container:
		option.container.get_child(0).scale -= Vector2.ONE * .2
	if selecting == option:
		selecting.update_progress(0, selecting_duration_target)
		selecting = null


func _on_option_gui_input(event, option):
	if event is InputEventMouseButton:
		if event.is_pressed():
			selecting = option
		elif event.is_released() and selecting == option:
			selecting.update_progress(0, selecting_duration_target)
			selecting = null
