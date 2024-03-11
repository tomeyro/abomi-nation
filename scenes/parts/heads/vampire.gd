extends Part


var hurt_cooldown_duration: float = 1.0
@onready var hurt_cooldown: float = hurt_cooldown_duration


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if char:
		hurt_cooldown = maxf(hurt_cooldown - delta, 0.0)
		if not hurt_cooldown:
			char.hurt(1 + (5 * (level - 1)))
			hurt_cooldown = hurt_cooldown_duration
