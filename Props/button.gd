extends Area2D

signal S_pressed

var pressed = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Tracker.check("button",position):
		queue_free()

func _on_body_entered(_body: Node2D) -> void:
	pressed = true
	S_pressed.emit()
	Tracker.add("button",position)
