extends Label
@onready var control: Control = $".."
@onready var spot_light_3d_sikodem: SpotLight3D = $"../../../sikodemDeath/SpotLight3D"
@onready var twoin = get_tree().create_tween()
@onready var animation_player_sikodem: AnimationPlayer = $"../../../sikodemDeath/AnimationPlayer"
@onready var label_2: Label = $"../Label2"
#await get_tree().create_timer(0.25).timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var twiin = get_tree().create_tween()
	twiin.tween_property(self, "scale", Vector2(1,1), 2.5).set_trans(Tween.TRANS_BOUNCE)
	#twiin.tween_callback(self.queue_free) # Replace with function body.
	#await get_tree().create_timer(1).timeout
	#scale.x=1
	animation_player_sikodem.play("sikodeadidle")
	twoin.tween_property(spot_light_3d_sikodem, "light_energy", randf_range(1.2,2.2), 0.1)
	
	label_2.text = "Death reason: Sikodem Nex got you!\n(try keeping an eye on the door)"
	
	await get_tree().create_timer(5).timeout
	twiin = get_tree().create_tween()
	twiin.tween_property(label_2, "modulate", Color.WHITE, 1.0)
	await get_tree().create_timer(7).timeout
	get_tree().change_scene_to_file("res://Scenes/mainmenu/mainmenu.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	control.size = get_viewport_rect().size
	twoin = get_tree().create_tween()
	twoin.tween_property(spot_light_3d_sikodem, "light_energy", randf_range(1.2,1.8), 0.1)
