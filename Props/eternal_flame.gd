extends Node2D

var lit = false

func _ready() -> void:
	if Tracker.check("eternalFlame",position):
		$AnimationPlayer.play("lightUp")
		lit = true
		

func _process(_delta: float) -> void:
	if global_position.y < Game.player.global_position.y+8:
		z_index = 0
	else:
		z_index = 1

func bodyEntered(_body: Node2D) -> void:
	if Game.player.hp > 0.0 and not lit:
		Tracker.add("eternalFlame",position)
		lit = true
		Game.respawn = [Game.currentMap,position+Vector2(0.0,16.0)]
		$AnimationPlayer.play("lightUp")
	if lit:
		Game.player.dark = false
		Game.player.restore()
