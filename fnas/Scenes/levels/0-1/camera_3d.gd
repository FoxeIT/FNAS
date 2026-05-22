extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.rotation_degrees.y = clamp(sin(((0.5-(get_viewport().get_mouse_position()/get_viewport().get_visible_rect().size).x))), -0.5,0.5)*160
	self.rotation_degrees.x = sin((((get_viewport().get_mouse_position()/get_viewport().get_visible_rect().size).y))-0.5)*-10
