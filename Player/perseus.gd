extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_range(0.0,100.0) var hp = 100.0
@export_enum("Boots","Helmet","Shield") var item = ""
@export_range(0.0,100.0) var itemDurability = 100.0

var dir = 'D'
var action = "Idle"
var attack
var dark = false
var door = ""
var dead = false
var itemActive = false

var bootMult = 1.0

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

func restart():
	Game.restart()
	dead = false
	dark = false
	hp = 100.0

func damage(dmg):
	hp -= dmg
	$Animation.play("hit")
	$Timers/T_Recover.start()
	if dark:
		$Animation.play("death")
		door = ""
		dead = true
		itemActive = false
	if hp <= 0.0:
		hp = 0.0
		dark = true

func restore():
	$Timers/T_Recover.stop()
	$Timers/T_Restore.start()

func getItem(i):
	item = i
	itemDurability = 100.0

func itemHandle():
	if item == "": return
	itemActive = !itemActive
	if item == "Boots":
		if itemActive: bootMult = 1.5
		else: bootMult = 1.0
	if item == "Helmet":
		if itemActive: $A_body.modulate.a = 0.25
		else: $A_body.modulate.a = 1.0
	if item == "Shield":
		pass

func isInvisible():
	return item == "Helmet" and itemActive

func isUsingBoots():
	return item == "Boots" and itemActive and velocity.length() > 0.0

func _physics_process(delta: float) -> void:
	if dead: return
	var dirX := Input.get_axis("Left", "Right")
	var dirY := Input.get_axis("Up", "Down")
	
	var run = Input.is_action_pressed("Run")
	
	#if Input.is_action_just_pressed("Hurt"):
		#damage(20.0)
	#
	if $Timers/T_Recover.is_stopped() and not dark:
		var res = 0.05
		if not $Timers/T_Restore.is_stopped():
			res = 0.6
		hp = move_toward(hp,100.0,res)
	
	attack = Input.is_action_just_pressed("Attack")
	
	var itemUsed = Input.is_action_just_pressed("Item")
	
	if itemUsed: itemHandle()
	
	if attack and $Timers/T_Attack.is_stopped():
		$Sword.play(dir)
		$Timers/T_Attack.start()
	
	if not $Timers/T_Attack.is_stopped():
		attack = true
	
	velocity = Vector2(dirX,dirY).normalized() * SPEED * delta * 20 * bootMult
	
	if run and velocity.length()>0.0:
		velocity *= 1.7
		hp = move_toward(hp,0.0,0.3)
		if hp <= 0.0: dark = true
	
	if attack: velocity *= 0.0
	
	if isUsingBoots(): itemDurability = move_toward(itemDurability,0.0,0.3)
	if isInvisible(): itemDurability = move_toward(itemDurability,0.0,0.1)
	
	if itemDurability <= 0.0:
		bootMult = 1.0
		$A_body.modulate.a = 1.0
		itemActive = false
		item = ""
	
	setDir()
	setAction()
	
	$A_body.play(action + dir)

	move_and_slide()


func _on_t_attack_timeout() -> void:
	attack = false


func damageEnemy(area: Area2D) -> void:
	area.get_parent().damage(10.0,dir)
