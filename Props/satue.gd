extends Node2D

@export_enum("Boots","Helmet","Shield") var item = ""
var used = false

func _ready() -> void:
	if Tracker.check("statue",position):
		used = true

func _process(_delta: float) -> void:
	pass

func bodyEntered(body: Node2D) -> void:
	if used: return
	used = true
	body.getItem(item)
	Tracker.add("statue",position)
