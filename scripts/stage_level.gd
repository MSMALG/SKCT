extends Node2D

@onready var ScenetransitionAnim =  $SceneTransitionAnim/AnimationPlayer
@onready var player_cam = $Player/Camera2D

var current_wave: int
@export var bat_scene: PackedScene

#wave sys
var startingNodes: int
var CurrentNodes: int
var wave_spawnEnded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScenetransitionAnim.get_parent().get_node("ColorRect").color.a = 255 #in case of glitching
	ScenetransitionAnim.play("fadeOut")
	player_cam.enabled = true
	Global.playerWeaponEquipped = true
	current_wave = 0
	Global.current_wave = current_wave
	startingNodes = get_child_count()
	CurrentNodes = get_child_count()
	position_to_next_wave()
	
func position_to_next_wave():
	if CurrentNodes == startingNodes:
		if current_wave != 0:
			Global.movingToNextWave = true
		#animation
		wave_spawnEnded =  false
		ScenetransitionAnim.play("betweenWave")
		current_wave +=1
		Global.current_wave = current_wave
		await get_tree().create_timer(0.5).timeout
		prepare_spawn("bats", 4.0, 4) #type, multiplie, spawns
		print(current_wave)
		
func prepare_spawn(type, multiplier, mob_spawns):
	var mob_amount = float(current_wave) * multiplier
	var mob_wait_time: float = 2.0
	print("mobAmount: ", mob_amount)
	var mob_spawn_rounds = mob_amount/mob_spawns
	spawn_type(type, mob_spawn_rounds, mob_wait_time)

func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	if type == "bats":
		var bat_spawn1 = $BatSpawnp1
		var bat_spawn2 = $BatSpawnp2
		var bat_spawn3 = $BatSpawnp3
		var bat_spawn4 = $BatSpawnp4
		
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var bat1 = bat_scene.instantiate()
				bat1.global_position = bat_spawn1.global_position
				var bat2 = bat_scene.instantiate()
				bat2.global_position = bat_spawn2.global_position
				var bat3 = bat_scene.instantiate()
				bat3.global_position = bat_spawn3.global_position
				var bat4 = bat_scene.instantiate()
				bat4.global_position = bat_spawn4.global_position
				add_child(bat1)
				add_child(bat2)
				add_child(bat3)
				add_child(bat4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
		wave_spawnEnded = true
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.PlayerAlive:
		Global.gameStart = false
		ScenetransitionAnim.play("fadeIn")
		await get_tree().create_timer(0.5).timeout
		update_score()
		get_tree().change_scene_to_file("res://scenes/lobby_level.tscn")
		
	CurrentNodes = get_child_count()
	
	if wave_spawnEnded:
		position_to_next_wave()
		
		
func update_score():
	Global.prevScore = Global.currentScore
	if Global.currentScore > Global.highScore:
		Global.highScore = Global.currentScore
	Global.currentScore = 0
	
