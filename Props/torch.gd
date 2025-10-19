extends Node2D

signal S_lit

@export var preLit = false
var lit = false

func _ready() -> void:
	if preLit:
		$Fire.play("lit")
		lit = true

func _process(_delta: float) -> void:
	pass


func playerEntered(_body: Node2D) -> void:
	if Game.player.hp > 0.0 and not lit:
		$Fire.play("lit")
		S_lit.emit()
		lit = true
	if lit:
		Game.player.dark = false
		Game.player.restore()

func playerExited(_body: Node2D) -> void:
	pass
