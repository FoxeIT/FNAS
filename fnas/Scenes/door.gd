extends Node3D
@export var open_angle_deg : float = 100.0   
@export var swing_duration : float = 0.6     
@export var swing_axis     : Vector3 = Vector3.UP  

@onready var hinge_point   : Node3D  = $HingePoint
@onready var interact_area : Area3D  = $InteractArea
@onready var prompt_label  : Label3D = $Label3D

var _is_open       : bool  = false
var _is_animating  : bool  = false
var _player_nearby : bool  = false

func _ready() -> void:

	prompt_label.visible = false


	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)

func _input(event: InputEvent) -> void:
	
	if not _player_nearby:
		return
	if _is_animating:
		return
	if event.is_action_pressed("interact"):  
		_toggle_door()

func _toggle_door() -> void:
	_is_animating = true
	prompt_label.visible = false

	var target_angle := deg_to_rad(open_angle_deg) if not _is_open else 0.0

	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(_set_door_angle, hinge_point.rotation.y, target_angle, swing_duration)
	tween.tween_callback(_on_tween_done)

func _set_door_angle(angle: float) -> void:
	hinge_point.rotation.y = angle

func _on_tween_done() -> void:
	_is_open      = !_is_open
	_is_animating = false
	if _player_nearby:
		prompt_label.text    = "Press E to close" if _is_open else "Press E to open"
		prompt_label.visible = true


func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:  
		_player_nearby        = true
		prompt_label.text     = "Press E to close" if _is_open else "Press E to open"
		prompt_label.visible  = true

func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		_player_nearby       = false
		prompt_label.visible = false
