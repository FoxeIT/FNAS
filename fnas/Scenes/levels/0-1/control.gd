extends Control
@onready var button: Button = $Button
@onready var button_2: Button = $Button2
@onready var camera_3d: Camera3D = $".."
var resettimer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(left)
	button_2.pressed.connect(right)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	resettimer += delta
	#if resettimer > 2:
		#camera_3d.rotation_degrees.y = 0

func left() -> void:
	camera_3d.rotation_degrees.y = 81.6
	resettimer = 0
	
func right() -> void:
	camera_3d.rotation_degrees.y = -81.6
	resettimer = 0
