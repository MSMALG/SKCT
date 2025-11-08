extends CharacterBody2D

class_name Player

@onready var AnimatedSprite = $AnimatedSprite2D
@onready var dealDamageZone = $DealDamageZone

const speed = 300.0
const Jump_Power = -350.0

#control attack
var attack_type: String 
var current_attack: bool
var weaponIsEquipped: bool

var gravity = 900
#var weaponIsEquipped: bool

#health 
var health = 100
var healthMax = 100
var healthMin = 0
var can_take_damage: bool
var dead: bool

func _ready():
	#weaponIsEquipped = false
	Global.playerBody = self
	current_attack = false
	dead = false
	can_take_damage = true
	Global.PlayerAlive = true
	
func _physics_process(delta):
	weaponIsEquipped = Global.playerWeaponEquipped
	Global.playerDamageZone = dealDamageZone
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if !dead:
	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = Jump_Power

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		if weaponIsEquipped and !current_attack:
			if Input.is_action_just_pressed("leftMJ") or Input.is_action_just_pressed("rightMJ"):
				current_attack = true
				if Input.is_action_pressed("leftMJ") and is_on_floor():
					attack_type = "single"
				elif  Input.is_action_pressed("rightMJ") and is_on_floor():
					attack_type = "double"
				else:
					attack_type = "air"
				set_damage(attack_type)
				handleAttack_animation(attack_type)
		handle_movement_animation(direction)
		checkHitbox()	
	move_and_slide()
	
func checkHitbox():
	var hitboxArea = $playerHitbox.get_overlapping_areas()
	var damage: int
	if hitboxArea:
		var hitbox = hitboxArea.front()
		if hitbox.get_parent() is BatEnemy:
			damage = Global.BatdamageAmount
	if can_take_damage:
		take_damage(damage)

func take_damage(damage):
	#print("test ", damage)
	if damage != 0:
		if health > 0:
			health -= damage
			print("health: ", health)
			if health <= 0:
				health = 0
				dead = true
				handle_death_animation() 
			takeDmgCooldown(1.0)
			
func handle_death_animation():
	$CollisionShape2D.position.y = 5
	AnimatedSprite.play("death")
	await get_tree().create_timer(.5).timeout
	$Camera2D.zoom.x = 4
	$Camera2D.zoom.y = 4
	await get_tree().create_timer(3.5).timeout
	Global.PlayerAlive = false
	self.queue_free()
	
func takeDmgCooldown(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true


func handle_movement_animation(dir):
	if !weaponIsEquipped:
		if is_on_floor():
			if !velocity:
				AnimatedSprite.play("idle")
			if velocity:
				AnimatedSprite.play("run")
				toggle_flip_sprite(dir)
		elif !is_on_floor():
			AnimatedSprite.play("fall")
	if weaponIsEquipped:
		if is_on_floor() and !current_attack:
			if !velocity:
				AnimatedSprite.play("weaponIdle")
			if velocity:
				AnimatedSprite.play("weaponRun")
				toggle_flip_sprite(dir)
		elif !is_on_floor() and !current_attack:
			AnimatedSprite.play("weaponFall")
			
func toggle_flip_sprite(dir):
	if dir == 1:
		AnimatedSprite.flip_h = false
		dealDamageZone.scale.x = 1  #without this line weapon area collision won't flip when we go to the opp dir.
	if dir == -1:
		AnimatedSprite.flip_h = true
		dealDamageZone.scale.x = -1

func handleAttack_animation(attack):
	if weaponIsEquipped:
		if current_attack:
			var animation = str(attack, "Attack")
			AnimatedSprite.play(animation)
			#print(animation)
			toggle_damageCollisions(attack_type)

func toggle_damageCollisions(Currentattack):
	var damageZone_collision = dealDamageZone.get_node("CollisionShape2D")
	var wait_time: float
	if Currentattack == "air":
		wait_time = 0.6  #framesNo. (4) / fps (5)
	elif Currentattack == "single":
		wait_time = 0.4 #6/15
	elif Currentattack == "double":
		wait_time = 0.7 #9/13
	damageZone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damageZone_collision.disabled = true


func _on_animated_sprite_2d_animation_finished() -> void:
	current_attack = false

#seeting dmg func
func set_damage(attack_type):
	var current_damageTodeal: int
	if attack_type == "single":
		current_damageTodeal = 8
	elif attack_type == "double":
		current_damageTodeal = 16
	elif attack_type == "air":
		current_damageTodeal = 20
	Global.playerDamageAmount = current_damageTodeal
