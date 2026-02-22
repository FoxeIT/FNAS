extends SpotLight3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var tween
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	tween = create_tween()
	tween.tween_property(self, "light_energy", randf_range(0.1,5.0), randf_range(0.3,0.7))
	await tween.finished
