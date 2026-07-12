extends Node2D
@onready var control: Control = $Control
@onready var camera_3d: Camera3D = $"../Camera3D"
@onready var camera_trigger: Button = $Control/cameraTrigger
@onready var upgrade_now: Button = $Control/upgradeNow
@onready var animation_player: AnimationPlayer = $"../jumpscares/AnimationPlayer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	upgrade_now.pressed.connect(_on_upgrade_press)
	camera_trigger.pressed.connect(_toggle_cameras)
	animation_player.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	control.size = get_viewport_rect().size
	if animation_player.current_animation == "deathSceneChange":
		get_tree().change_scene_to_file("res://Scenes/levels/0-1/deathscenes.tscn")

func _toggle_cameras():
	if animation_player.current_animation != "jumpscare_sikodem_1":
		animation_player.animation_set_next("jumpscare_sikodem_1", "deathSceneChange")
		animation_player.play("jumpscare_sikodem_1")
	

func _on_upgrade_press():
	$"../SubViewport/Control/Screen3".visible = true
	upgrade_now.disabled = true
	for i in range(0,2):
		$"../SubViewport/Control/Screen4".visible = false
		for e in range(0,3):
			upgrade_now.text = "o.."
			await get_tree().create_timer(0.25).timeout
			upgrade_now.text = ".o."
			await get_tree().create_timer(0.25).timeout
			upgrade_now.text = "..o"
			await get_tree().create_timer(0.25).timeout
			upgrade_now.text = "..."
			await get_tree().create_timer(0.25).timeout
		$"../SubViewport/Control/Screen4".visible = true
		upgrade_now.text = "!!!"
		await get_tree().create_timer(2).timeout
	$"../SubViewport/Control/Screen2".visible = true
	upgrade_now.remove_theme_color_override("font_disabled_color")
	upgrade_now.add_theme_color_override("font_disabled_color", Color(255, 0, 0))
	upgrade_now.text = "Failed..."
	await get_tree().create_timer(2).timeout
	var twiin = get_tree().create_tween()
	twiin.tween_property(upgrade_now, "position", Vector2(upgrade_now.position.x,get_viewport_rect().size.y+300), 1.0).set_trans(Tween.TRANS_CUBIC)
	twiin.tween_callback(upgrade_now.queue_free)
	await get_tree().create_timer(3).timeout
	$"../SubViewport/Control/Screen2".visible = false
	$"../SubViewport/Control/Screen4".visible = false
	$"../SubViewport/Control/Screen3".visible = false
	
