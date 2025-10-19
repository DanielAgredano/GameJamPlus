extends Node2D

var lit = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if global_position.y < $"../../Perseus".global_position.y+8:
		z_index = 0
	else:
		z_index = 1

func bodyEntered(_body: Node2D) -> void:
	if Game.player.hp > 0.0 and not lit:
		$Fire.play("lit")
		lit = true
		$AnimationPlayer.play("lightUp")
	if lit:
		Game.player.dark = false
		Game.player.restore()
