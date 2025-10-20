extends Node

var checks = []

func add(type,info = null):
	checks.append([Game.currentMap,type,info])

func check(type,info):
	return [Game.currentMap,type,info] in checks

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
