extends Node2D

@onready var ScenetransitionAnim =  $SceneTransitionAnim/AnimationPlayer
@onready var player_cam = $Player/Camera2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScenetransitionAnim.get_parent().get_node("ColorRect").color.a = 255 #in case of glitching
	ScenetransitionAnim.play("fadeOut")
	player_cam.enabled = false
	Global.playerWeaponEquipped = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		#print(body)
		Global.gameStart =  true
		ScenetransitionAnim.play("fadeIn")
		await get_tree().create_timer(.5).timeout
		get_tree().change_scene_to_file("res://scenes/stage_level.tscn")
