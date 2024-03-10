#@tool
extends Node2D


@export var bodies: Array[PartResource]
@export var heads: Array[PartResource]
@export var arms: Array[PartResource]
@export var legs: Array[PartResource]


@onready var bodies_count: int = %Bodies.get_child_count()
@onready var heads_count: int = %Heads.get_child_count()
@onready var arms_count: int = %Arms.get_child_count()
@onready var legs_count: int = %Legs.get_child_count()


func _process(delta: float) -> void:
	_update_body()


func _update_body() -> void:
	var empty: Array[PartResource] = []
	_update_parts(bodies if bodies else empty, %Bodies)
	_update_parts(heads if heads else empty, %Heads)
	_update_parts(arms if arms else empty, %Arms)
	_update_parts(legs if legs else empty, %Legs)


func _update_part(part_res: PartResource, parent: Node2D):
	var child: Part
	if parent.get_children():
		child = parent.get_child(0)
	if child and child.resource != part_res:
		parent.remove_child(child)
		child.queue_free()
		child = null
	if not child and part_res:
		var part: Part = part_res.tscn.instantiate()
		parent.add_child(part)


func _update_parts(part_resources: Array[PartResource], parent: Node2D):
	for idx in range(10):
		var part_parent: String = "Slot" + str(idx + 1)
		if parent.has_node(part_parent):
			var part_res = part_resources[idx] if len(part_resources) > idx else null
			_update_part(part_res, parent.get_node(part_parent))
		else:
			break


func get_part(part_name: String, part_idx: int):
	var part_container: Marker2D = get_node(part_name.to_lower().capitalize()).get_child(part_idx)
	if part_container.get_child_count():
		return part_container.get_child(0)
	return null


func level_up_part(part_name: String, part_idx: int):
	print("LEVEL UP PART!!", get_part(part_name, part_idx))