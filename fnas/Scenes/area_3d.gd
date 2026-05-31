extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.body_entered.connect(trigger_lv_change) # Replace with function body.

func trigger_lv_change(body: Node3D) -> void:
	if body is CharacterBody3D:
		if body.is_in_group("player"):
			get_tree().change_scene_to_file("res://Scenes/levels/0-1/lv0_1_1.tscn")
