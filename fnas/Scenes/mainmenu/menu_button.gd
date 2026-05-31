extends Button
@onready var animator: AnimationPlayer = $"../../AnimationPlayer"

enum BtnActions {
	NEWGAME, CONTINUE, EXIT
}

@export var btn_type: BtnActions = BtnActions.EXIT


func _ready():
	self.connect("pressed", _pressed)
	animator.play("RESET")

func _pressed():
	if self.disabled: return
	
	match btn_type:
		BtnActions.NEWGAME:
			if !animator.animation_finished.is_connected(_transition_end):
				$"../../ColorRect".visible = true
				animator.animation_finished.connect(_transition_end)
				animator.play("fadeoutffs")
		
		BtnActions.EXIT:
			get_tree().quit(67)

func _transition_end(thisIsAbsolutelyNecessaryForSomeReason):
	get_tree().change_scene_to_file("res://testy/asciiintro.tscn")
