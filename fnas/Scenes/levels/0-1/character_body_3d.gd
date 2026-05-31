extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var door_left_light: SpotLight3D = $"../../office-0_1_1/doorLeftLight"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if door_left_light.visible and animation_player.current_animation != "idle_door":
		animation_player.play("idle_door")
	elif !door_left_light.visible and animation_player.current_animation != "RESET":
		animation_player.play("RESET")
