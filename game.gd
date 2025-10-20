extends Node

var player
var map
var game
var respawn = [1,Vector2(0,0)]

var currentMap = 1

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func loadMap(newMap):
	currentMap = newMap
	newMap = load("res://Maps/map["+str(newMap)+"].tscn").instantiate()
	game.call_deferred("add_child",newMap)

func restart():
	map.queue_free()
	currentMap = respawn[0]
	var newMap = respawn[0]
	newMap = load("res://Maps/map["+str(newMap)+"].tscn").instantiate()
	game.call_deferred("add_child",newMap)
	player.position = respawn[1]
