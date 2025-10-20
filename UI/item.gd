extends AnimatedSprite2D

@onready var player = Game.player

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	modulate.a = 1.0 if player.itemActive else 0.5
	if player.item == "":
		animation = "default"
	else:
		animation = player.item
