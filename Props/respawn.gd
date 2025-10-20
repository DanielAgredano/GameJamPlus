extends Marker2D

@export var ID = ""
@onready var player = Game.player

func _ready() -> void:
	if player.door == ID:
		player.position = position

func _process(_delta: float) -> void:
	pass
