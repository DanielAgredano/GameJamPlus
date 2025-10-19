extends Node2D


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	if global_position.y < $"../../Perseus".global_position.y+8:
		z_index = 0
	else:
		z_index = 1
