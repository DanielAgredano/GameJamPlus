extends RemoteTransform2D

const dirEq = {
	'U':Vector2( 0,-1),
	'D':Vector2( 0, 1),
	'L':Vector2(-1, 0),
	'R':Vector2( 1, 0),
}

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	position = dirEq[$"..".dir]*32
