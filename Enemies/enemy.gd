extends CharacterBody2D

signal S_death

const SPEED = 1200.0
const MULT = 2.5
const JUMP_VELOCITY = -400.0
var angle = 0.0
var dmg = 20.0
var hp = 30.0
var knockback

const knockV = {
	'U':Vector2( 0,-1),
	'D':Vector2( 0, 1),
	'L':Vector2(-1, 0),
	'R':Vector2( 1, 0),
}

func _ready() -> void:
	angle = deg_to_rad(randf_range(0.0,360.0))

func damage(d,k):
	hp-= d
	knockback = k
	$T_knockback.start()
	if hp <= 0.0:
		S_death.emit()
		queue_free()

func _physics_process(delta: float) -> void:
	var extraSpeed = 1.0
	if $Vision.get_overlapping_bodies() and not Game.player.isInvisible():
		angle = position.angle_to_point(Game.player.position + Vector2(0.0,+8.0))
		extraSpeed = MULT
	
	if is_on_wall():
		angle = velocity.bounce(get_wall_normal()).angle()
	
	if not $T_knockback.is_stopped():
		angle = knockV[knockback].angle()
		extraSpeed = 8.0
	
	velocity = SPEED * delta * Vector2(1.0,0.0).rotated(angle) * extraSpeed
	
		
	move_and_slide()


func damagePlayer(area: Area2D) -> void:
	area.get_parent().damage(dmg)
