extends Node2D

@export var map = 0

func _ready() -> void:
	Game.map = $"."

func _process(_delta: float) -> void:
	pass
