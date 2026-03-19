extends CharacterBody3D

const SPEED = 7.0
const JUMP_VELOCITY = 7.0
const MOUSE_SENSITIVITY = 0.003 # Czułość myszy
const STEPSOUND_DELAY_MIN = 0.4
const STEPSOUND_DELAY_MAX = 0.5

@onready var camera = $Camera3D # Pobiera referencję do kamery
@onready var stepemitter = $StepPlayer
@onready var jumpemitter = $JumpPlayer
@onready var nsactivateemitter = $NSActivate
@onready var uiNightshot = $UI/CAMNS
@onready var uiNightshotShader = $UI/NightshotShader
@onready var nightshotLight = $NSLight
@onready var flashLight = $Camera3D/FlashLight

func _ready():
	# Blokuje kursor myszy na środku ekranu
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Obsługa ruchu myszą
	if event is InputEventMouseMotion:
		# Obrót gracza lewo/prawo (oś Y)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		# Obrót kamery góra/dół (oś X)
		camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		# Ograniczenie patrzenia w górę/dół do 90 stopni (klampowanie)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event.pressed:
			match event.button_index:
				2:
					uiNightshot.visible = true
					uiNightshotShader.visible = true
					nightshotLight.visible = true
					flashLight.visible = false
					nsactivateemitter.play()
		else:
			match event.button_index:
				2:
					uiNightshot.visible = false
					uiNightshotShader.visible = false
					nightshotLight.visible = false
					flashLight.visible = true
					nsactivateemitter.stop()

var stepdelay: float = 0

func _physics_process(delta: float) -> void:
	var size = get_viewport().get_visible_rect().size
	uiNightshotShader.size = size
	uiNightshot.size = size
	
	# Wyjście z gry/odblokowanie myszy po ESC
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	# Grawitacja
	if not is_on_floor():
		velocity += get_gravity() * 1.5 * delta

	# Skok
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumpemitter.pitch_scale = randf_range(0.95,1.00)
		jumpemitter.play(0.15)

	# Poruszanie się (używamy transform.basis, który teraz uwzględnia obrót myszą)
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if not stepemitter.playing and is_on_floor() and stepdelay <= 0:
			stepemitter.pitch_scale = randf_range(0.9,1.1)
			stepemitter.play()
			stepdelay = randf_range(STEPSOUND_DELAY_MIN, STEPSOUND_DELAY_MAX)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/10.0)
		velocity.z = move_toward(velocity.z, 0, SPEED/10.0)

	if stepdelay > 0: stepdelay -= delta

	move_and_slide()
