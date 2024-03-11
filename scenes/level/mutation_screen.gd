extends Control

@onready var mutation_block_1: ColorRect = $MutationBlock1
@onready var mutation_block_2: ColorRect = $MutationBlock2

var hovering: PartResource
var hovering_action: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Signals.mutation.connect(_on_mutation)

	mutation_block_1.selected.connect(_on_mutation_selected)
	mutation_block_2.selected.connect(_on_mutation_selected)
	mutation_block_1.hover.connect(_on_mutation_hover)
	mutation_block_2.hover.connect(_on_mutation_hover)
	mutation_block_1.hover_ended.connect(_on_mutation_hover_ended)
	mutation_block_2.hover_ended.connect(_on_mutation_hover_ended)


func _process(delta: float) -> void:
	%MutationTitle.visible = false
	%MutationDescription.visible = false
	%MutationActions.visible = false
	if hovering:
		%MutationTitle.visible = true
		%MutationTitle.text = hovering.title
		%MutationDescription.visible = true
		%MutationDescription.text = hovering.description
		%MutationActions.visible = true
		%MutationActions/Replace.visible = hovering_action == "replace"
		%MutationActions/Upgrade.visible = hovering_action == "upgrade"
		%MutationActions/New.visible = hovering_action == "new"
		%MutationActions/None.visible = hovering_action == "none"


func _on_mutation(char: Char) -> void:
	get_tree().paused = true
	mutation_block_1.randomize_option(char)
	mutation_block_2.randomize_option(char, mutation_block_1.part_res)
	visible = true


func _on_mutation_selected(_part_res: PartResource) -> void:
	get_tree().paused = false
	visible = false


func _on_mutation_hover(part_res: PartResource, action: String) -> void:
	hovering = part_res
	hovering_action = action


func _on_mutation_hover_ended(part_res: PartResource) -> void:
	if part_res == hovering:
		hovering = null
