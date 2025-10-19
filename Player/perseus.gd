extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_range(0.0,100.0) var hp = 100.0

var dir = 'D'
var action = "Idle"
var attack
var dark = false

const dirAxis = {
	'U':'V',
	'D':'V',
	'L':'H',
	'R':'H',
}

const invDirs = {
	'Up':'Down',
	'Down':'Up',
	'Left':'Right',
	'Right':'Left',
}

func _ready() -> void:
	Game.player = $"."

func get_axis():
	var cDir = [Input.get_axis("Left", "Right"),Input.get_axis("Up", "Down")]
	if cDir[0] and cDir[1]:
		return 'B'
	if cDir[0]:
		return 'H'
	if cDir[1]:
		return 'V'
	return 'N'

func get_facing_axis():
	if dir in ['L','R']:
		return 'H'
	return 'V'

func changeDirection():
	if attack: return
	var axisD = get_axis()
	if axisD=='B':
		axisD = dir
	if axisD=='H':
		dir = 'L' if Input.get_axis("Left", "Right")<0 else 'R'
	if axisD=='V':
		dir = 'D' if Input.get_axis("Up", "Down")>0 else 'U'

func setDir():
	var newDir = ""
	if Input.is_action_pressed("Down"):
		newDir = 'D'
	if Input.is_action_pressed("Up"):
		newDir = 'U'
	if Input.is_action_pressed("Left"):
		newDir = 'L'
	if Input.is_action_pressed("Right"):
		newDir = 'R'
	if newDir == "": return
	changeDirection()
	
	

func setAction():
	var walkActions = ["Up","Down","Left","Right"]
	if attack:
		action = "Attack"
		return
	for actionC in walkActions:
		if Input.is_action_pressed(actionC):
			if Input.is_action_pressed(invDirs[actionC]):
				action = "Idle"
			else:
				if Input.is_action_pressed("Run"):
					action = "Run"
				else:
					action = "Walk"
			return
	action = "Idle"

func damage(dmg):
	hp -= dmg
	$Timers/T_Recover.start()
	if hp <= 0.0:
		hp = 0.0
		dark = true

func restore():
	$Timers/T_Recover.stop()
	$Timers/T_Restore.start()

func _physics_process(delta: float) -> void:
	var dirX := Input.get_axis("Left", "Right")
	var dirY := Input.get_axis("Up", "Down")
	
	var run = Input.is_action_pressed("Run")
	
	if Input.is_action_just_pressed("Hurt"):
		damage(20.0)
	
	if $Timers/T_Recover.is_stopped() and not dark:
		var res = 0.05
		if not $Timers/T_Restore.is_stopped():
			res = 0.6
		hp = move_toward(hp,100.0,res)
	
	attack = Input.is_action_just_pressed("Attack")
	
	if attack and $Timers/T_Attack.is_stopped():
		$Timers/T_Attack.start()
	
	if not $Timers/T_Attack.is_stopped():
		attack = true
	
	velocity = Vector2(dirX,dirY).normalized() * SPEED * delta * 20
	
	if run: velocity *= 1.7
	
	if attack: velocity *= 0.0
	
	setDir()
	setAction()
	
	$A_body.play(action + dir)

	move_and_slide()


func _on_t_attack_timeout() -> void:
	attack = false
