extends Node2D

@export var destinationMap = 0
@export var destination = ""

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func bodyEntered(body: Node2D) -> void:
	body.door = destination
	Game.loadMap(destinationMap)
	Game.map.queue_free()
	
