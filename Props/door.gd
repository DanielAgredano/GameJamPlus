extends Node2D

var open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Tracker.check("door",position):
		$AnimationPlayer.play("open")
		open = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if global_position.y < Game.player.global_position.y+8:
		z_index = 0
	else:
		z_index = 1
	if open:
		z_index = 0

func unlock():
	$AnimationPlayer.play("lower")
	Tracker.add("door",position)
	open = true
