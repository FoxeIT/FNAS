extends CharacterBody3D

var deltaura = 0
const SPEED = 2.0
const JUMP_VELOCITY = 4.5
@onready var player = get_tree().get_current_scene().find_child("Player")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var area_3d: Area3D = $Area3D

func _ready() -> void:
	area_3d.body_entered.connect(_touched)

func _physics_process(delta: float) -> void:
	deltaura += delta
	if deltaura > 0.1:
		var position = player.position
		navigation_agent_3d.set_target_position(position)
	var destination = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	velocity = velocity * Vector3(0.99,1,0.99)
	velocity += direction * SPEED * delta * 10 * Vector3(1,0.1,1)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	$Sprite3D.look_at(player.position+Vector3(0,3,0))
	move_and_slide()

func _touched(body: Node3D):
	if body == player:
		self.position = Vector3(0,2,0)
