extends CharacterBody2D
class_name Char

var base_movement_speed := 200.0
var movement_speed_step := 25.0
var movement_speed = 0.0

@onready var body: Node2D = %Body

var mutation_count: int = 0
var mutation_speed: float = 1.0
var mutation_current: float = 0.0
var mutation_target: float = 5.0
var mutation_percentage: float:
	get:
		return mutation_current * 100.0 / mutation_target

var life: float= 100.0
var max_life: float = 100.0
var life_percentage: float:
	get:
		return life * 100.0 / max_life


func _ready() -> void:
	Globals.char = self


func _physics_process(delta: float) -> void:
	_update_stats()
	_handle_movement()
	_update_mutation(delta)


func _update_stats():
	movement_speed = base_movement_speed + (movement_speed_step * body.stats["speed"])


func _handle_movement():
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * movement_speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)

	if (velocity.x < 0 and %Body.scale.x > 0) or (velocity.x > 0 and %Body.scale.x < 0):
		%Body.scale.x = -%Body.scale.x

	if velocity == Vector2.ZERO:
		(%Body/AnimationPlayer as AnimationPlayer).pause()
	else:
		(%Body/AnimationPlayer as AnimationPlayer).play()

	move_and_slide()


func _update_mutation(delta: float):
	mutation_current += delta * mutation_speed
	if mutation_current >= mutation_target:
		_mutate()
		mutation_current -= mutation_target


func _mutate():
	mutation_count += 1
	Signals.mutation.emit(self)


func hurt(damage: float) -> void:
	life = max(life - damage, 0.0)
	if not life:
		_die()


func _die() -> void:
	print("you died")
	Globals.start_game()
