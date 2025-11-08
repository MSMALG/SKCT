extends CharacterBody2D

class_name BatEnemy

const speed = 30
var dir: Vector2

var isBatChase: bool
var player: CharacterBody2D

#health
var health = 50
var healthMax = 50
var heathMin = 0
var dead = false
var taking_damage = false
var is_roaming: bool

#damage to player
var damageToDeal = 12

var pointsForKill = 100

func _ready() -> void:
	isBatChase = true

func _process(delta):
	Global.BatdamageAmount = damageToDeal
	Global.BatdamageZone = $BatDealtDamageArea
	
	if Global.PlayerAlive:
		isBatChase = true
	elif !Global.PlayerAlive:
		isBatChase = false
	
	if is_on_floor() and dead:
		await get_tree().create_timer(3.0). timeout
		Global.currentScore += pointsForKill
		self.queue_free()
		
	move(delta)
	handle_animations()

#Follow the player 
func move(delta):
	player = Global.playerBody
	if !dead:
		is_roaming = true
		if !taking_damage and isBatChase and Global.PlayerAlive:
			velocity = position.direction_to(player.position) * speed
			#print(abs(velocity.x) / velocity.x) #change the direction of the bat
			dir.x = abs(velocity.x)/velocity.x
		elif taking_damage:
			var knockbackDir = position.direction_to(player.position) * -50
			velocity = knockbackDir
		#elif !isBatChase:
		else:
			velocity += dir * speed * delta
	elif dead:
		velocity.y += 10 * delta
		velocity.x = 0
	move_and_slide()

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([.5, .8])
	if !isBatChase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		#print(dir)

func handle_animations():
	var AnimatedSprite = $AnimatedSprite2D
	if !dead and !taking_damage:
		AnimatedSprite.play("fly")
		if dir.x == -1:
			AnimatedSprite.flip_h = true
		elif dir.x == 1:
			AnimatedSprite.flip_h = false
	elif !dead and taking_damage:
		AnimatedSprite.play("hurt")
		await get_tree().create_timer(.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		AnimatedSprite.play("death")
		set_collision_layer_value(1, true)
		set_collision_layer_value(2, false)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
	
func choose(array):
	array.shuffle()
	return array.front()


func _on_bat_hitbox_area_entered(area: Area2D) -> void:
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		takeDamage(damage)
		
func takeDamage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), "current health is ", health)
	
