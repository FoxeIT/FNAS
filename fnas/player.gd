extends CharacterBody3D


const SPEED               = 7.0
const JUMP_VELOCITY       = 7.0
const MOUSE_SENSITIVITY   = 0.003
const STEPSOUND_DELAY_MIN = 0.4
const STEPSOUND_DELAY_MAX = 0.5

const HAND_BOB_SPEED      = 9.0
const HAND_BOB_AMOUNT_Y   = 0.018
const HAND_BOB_AMOUNT_X   = 0.009
const HAND_REST_POS       = Vector3(0.0, 0.0, 0.0)

const HAND_SWAY_AMOUNT    = 0.0025
const HAND_SWAY_SPEED     = 6.0
const HAND_LERP_SPEED     = 8.0

@onready var camera            : Camera3D            = $Camera3D
@onready var stepemitter       : AudioStreamPlayer3D = $StepPlayer
@onready var jumpemitter       : AudioStreamPlayer3D = $JumpPlayer
@onready var nsactivateemitter : AudioStreamPlayer3D = $NSActivate
@onready var uiNightshot       : Control             = $UI/CAMNS
@onready var uiNightshotShader : Control             = $UI/NightshotShader
@onready var nightshotLight                          = $NSLight
@onready var flashLight                              = $Camera3D/FlashLight
@onready var noiseFX                                 = $UI/VideoStreamPlayer
@onready var hands_root  : Node3D          = $Camera3D/HandsRoot
@onready var anim_player : AnimationPlayer = $Camera3D/HandsRoot/AnimationPlayer

var _step_delay   : float   = 0.0
var _bob_time     : float   = 0.0
var _mouse_delta  : Vector2 = Vector2.ZERO
var _was_on_floor : bool    = true
var _current_anim : String  = ""

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_set_hand_layer($Camera3D/HandsRoot/idk2, 2)
	_set_hand_layer($Camera3D/HandsRoot/idk,  2)
	_play_anim("idle")

func _set_hand_layer(mesh: MeshInstance3D, layer: int) -> void:
	if mesh == null:
		return
	for i in range(1, 21):
		mesh.set_layer_mask_value(i, false)
	mesh.set_layer_mask_value(layer, true)

func _input(event: InputEvent) -> void:
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		_mouse_delta = event.relative

	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_RIGHT:
					uiNightshot.visible       = true
					uiNightshotShader.visible = true
					nightshotLight.visible    = true
					flashLight.visible        = false
					noiseFX.visible           = true
					nsactivateemitter.play(0.15)
		else:
			match event.button_index:
				MOUSE_BUTTON_RIGHT:
					uiNightshot.visible       = false
					uiNightshotShader.visible = false
					nightshotLight.visible    = false
					flashLight.visible        = true
					noiseFX.visible           = false
					nsactivateemitter.stop()

func _physics_process(delta: float) -> void:
	var size := get_viewport().get_visible_rect().size
	uiNightshotShader.size = size
	uiNightshot.size       = size

	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if not is_on_floor():
		velocity += get_gravity() * 1.5 * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpemitter.pitch_scale = randf_range(0.95, 1.00)
		jumpemitter.play(0.15)

	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if not stepemitter.playing and is_on_floor() and _step_delay <= 0.0:
			stepemitter.pitch_scale = randf_range(0.9, 1.1)
			stepemitter.play()
			_step_delay = randf_range(STEPSOUND_DELAY_MIN, STEPSOUND_DELAY_MAX)
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED / 10.0)
		velocity.z = move_toward(velocity.z, 0.0, SPEED / 10.0)

	if _step_delay > 0.0:
		_step_delay -= delta

	_update_hands(delta, direction)
	move_and_slide()
	_was_on_floor = is_on_floor()

func _update_hands(delta: float, direction: Vector3) -> void:
	var on_floor  := is_on_floor()
	var is_moving := direction.length() > 0.1 and on_floor

	if is_moving:
		_bob_time += delta * HAND_BOB_SPEED
		var bob := Vector3(
			cos(_bob_time)       * HAND_BOB_AMOUNT_X,
			sin(_bob_time * 2.0) * HAND_BOB_AMOUNT_Y,
			0.0
		)
		hands_root.position = hands_root.position.lerp(HAND_REST_POS + bob, delta * HAND_LERP_SPEED)
	else:
		_bob_time = 0.0
		hands_root.position = hands_root.position.lerp(HAND_REST_POS, delta * HAND_LERP_SPEED)

	var sway_target := Vector3(
		-_mouse_delta.y * HAND_SWAY_AMOUNT,
		-_mouse_delta.x * HAND_SWAY_AMOUNT,
		0.0
	)
	hands_root.rotation = hands_root.rotation.lerp(sway_target, delta * HAND_SWAY_SPEED)
	_mouse_delta = Vector2.ZERO

	if not on_floor and _was_on_floor:
		_play_anim("jump")
	elif on_floor and not _was_on_floor:
		_play_anim("land")
	elif on_floor:
		if is_moving:
			_play_anim("walk")
		else:
			if _current_anim in ["jump", "land"]:
				if not anim_player.is_playing():
					_play_anim("idle")
			else:
				_play_anim("idle")

func _play_anim(anim_name: String) -> void:
	if _current_anim == anim_name:
		return
	if anim_player == null:
		return
	if not anim_player.has_animation(anim_name):
		return
	_current_anim = anim_name
	anim_player.play(anim_name)
