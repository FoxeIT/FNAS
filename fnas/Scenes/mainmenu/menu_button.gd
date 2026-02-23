extends Button

enum BtnActions {
	NEWGAME, CONTINUE, EXIT
}

@export var btn_type: BtnActions = BtnActions.EXIT

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", _pressed)

func _pressed():
	if self.disabled: return
	
	match btn_type:
		BtnActions.NEWGAME:
			var tween = create_tween()
			tween.connect("finished", _transition_end)
			tween.tween_property(get_tree().current_scene, "modulate", Color(0, 0, 0), 2.0)
		
		BtnActions.EXIT:
			get_tree().quit(67)

func _transition_end():
	get_tree().change_scene_to_file("res://Scenes/biggayytest.tscn")
