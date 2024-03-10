extends Node2D


var speed: float = 75.0

var char: Char
var attack_cooldown_duration := 0.5
var attack_cooldown := 0.0

var damage := 10.0


func _ready() -> void:
	_load_body()
	_randomize_values()


func _load_body() -> void:
	for part in ["heads", "bodies", "arms", "legs"]:
		var parts: Array[PartResource] = []
		for i in range(randi_range(1, %Body[part + "_count"])):
			var part_res: PartResource = Globals.parts[part].pick_random()
			parts.append(part_res)
		%Body[part] = parts


func _randomize_values() -> void:
	scale = Vector2.ONE * randf_range(0.5, 1.5)
	if scale.x < 1.0:
		speed += 100 * (1.0 - scale.x)
	else:
		speed -= 50 * (scale.x - 1.0)


func _physics_process(delta: float) -> void:
	_handle_free()
	_handle_movement(delta)
	_handle_attack(delta)


func _handle_free() -> void:
	var distance_to_char := global_position - Globals.char.global_position
	var distance_to_free := Globals.window_size * 0.85
	if abs(distance_to_char.x) >= distance_to_free.x or abs(distance_to_char.y) >= distance_to_free.y:
		queue_free()


func _handle_movement(delta: float) -> void:
	var target := Globals.char.global_position - (global_position.direction_to(Globals.char.global_position) * 25)
	if (target.x < global_position.x and %Body.scale.x > 0) or (target.x > global_position.x and %Body.scale.x < 0):
		%Body.scale.x = -%Body.scale.x
	global_position = global_position.move_toward(target, delta * speed)


func _on_hurt_box_area_entered(area: Area2D) -> void:
	char = area.get_parent()


func _on_hurt_box_area_exited(area: Area2D) -> void:
	char = null


func _handle_attack(delta: float) -> void:
	attack_cooldown = max(attack_cooldown - delta, 0.0)
	if char and not attack_cooldown:
		char.hurt(damage)
		attack_cooldown = attack_cooldown_duration
