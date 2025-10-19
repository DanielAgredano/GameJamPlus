extends Sprite2D

@onready var player: CharacterBody2D = $"../Perseus"
@onready var fill: Sprite2D = $"../CanvasLayer/Control/Base/Fill"
@onready var fire: AnimatedSprite2D = $"../CanvasLayer/Control/Fire"


func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	material.set_shader_parameter("transparency",1.0-(player.hp/150.0))
	material.set_shader_parameter("radius",0.045+0.1*(player.hp/100.0))
	$DarkRoom2.modulate.a = 1.0-(player.hp/100.0)-0.25
	fill.position.y = 22.0 * (1.0-(player.hp/100.0))
	fire.speed_scale = (player.hp/100.0)
	fire.modulate.a = (player.hp/100.0)
