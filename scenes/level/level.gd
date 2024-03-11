extends Node2D


var spawn_cooldown_duration := 0.5
var spawn_cooldown := 0.0
var spawn_max := 300

@onready var enemy_tscn := preload("res://scenes/enemy/enemy.tscn")


func _ready() -> void:
	_spawn(20)


func _process(delta: float) -> void:
	%Background.global_position = %Char.global_position - ((%Background as ColorRect).get_rect().size / 2.0)
	(%Background.material as ShaderMaterial).set_shader_parameter("offset", %Char.global_position)
	_handle_spawn(delta)


func _handle_spawn(delta: float) -> void:
	spawn_cooldown = max(spawn_cooldown - delta, 0.0)
	if not spawn_cooldown:
		_spawn()
		spawn_cooldown = spawn_cooldown_duration


func _spawn(qty: int = 1) -> void:
	if not Globals.char or %Enemies.get_child_count() >= spawn_max or Globals.window_size == Vector2.ZERO:
		return
	for i in range(qty):
		var spawn_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		spawn_direction[abs(spawn_direction).max_axis_index()] = 1.0 * sign(spawn_direction[abs(spawn_direction).max_axis_index()])
		var spawn_position: Vector2 = %Char.global_position + (spawn_direction * (Globals.window_size * 0.75))
		var enemy = enemy_tscn.instantiate()
		enemy.global_position = spawn_position
		var z_index = 990 - (10 * %Enemies.get_child_count())
		while z_index < -990:
			z_index += 990 * 2
		enemy.z_index = z_index
		%Enemies.add_child(enemy)
