extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_meta("isControllable", true):
		self.rotation_degrees.y = clamp(sin(((0.5-(get_viewport().get_mouse_position()/get_viewport().get_visible_rect().size).x))), -0.5,0.5)*160
		self.rotation_degrees.x = sin((((get_viewport().get_mouse_position()/get_viewport().get_visible_rect().size).y))-0.5)*-10
