extends Label
@onready var control: Control = $".."
#await get_tree().create_timer(0.25).timeout

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var twiin = get_tree().create_tween()
	twiin.tween_property(self, "scale", Vector2(1,1), 1.0).set_trans(Tween.TRANS_BOUNCE)
	#twiin.tween_callback(self.queue_free) # Replace with function body.
	#await get_tree().create_timer(1).timeout
	#scale.x=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	control.size = get_viewport_rect().size
