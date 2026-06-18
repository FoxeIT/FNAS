extends Camera3D

var _last_input := "mouse"

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta: float) -> void:
	if not get_meta("isControllable", true):
		return

	if _last_input == "joy":
		var joy_cam := Vector2.ZERO
		for device in Input.get_connected_joypads():
			joy_cam = Vector2(Input.get_joy_axis(device, 2), Input.get_joy_axis(device, 3))
			break
		if joy_cam.length() > 0.15:
			self.rotation_degrees.y += -joy_cam.x * 120.0 * delta
			self.rotation_degrees.x += -joy_cam.y * 60.0 * delta
			self.rotation_degrees.y = clamp(self.rotation_degrees.y, -80, 80)
			self.rotation_degrees.x = clamp(self.rotation_degrees.x, -10, 10)
	else:
		var mouse_pos := get_viewport().get_mouse_position()
		var viewport_size := get_viewport().get_visible_rect().size
		if viewport_size.x > 0 and viewport_size.y > 0:
			var rel := mouse_pos / viewport_size
			rotation_degrees.y = clamp(sin((0.5 - rel.x)), -0.5, 0.5) * 160
			rotation_degrees.x = sin((rel.y) - 0.5) * -10

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_last_input = "mouse"
	elif event is InputEventJoypadMotion and (event.axis == 2 or event.axis == 3) and abs(event.axis_value) > 0.15:
		_last_input = "joy"
