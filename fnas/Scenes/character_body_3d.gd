extends CharacterBody3D

var deltaura = 0
const SPEED = 2.0
const JUMP_VELOCITY = 9.0
@onready var player = get_tree().get_current_scene().find_child("Player")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var area_3d: Area3D = $Area3D
@onready var music: AudioStreamPlayer3D = $Music

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
	if is_on_floor():
		velocity = velocity * Vector3(0.99,1,0.99)
		velocity += direction * SPEED * delta * 10 * Vector3(1,1,1)
	else:
		velocity += direction * SPEED * delta * 10 * Vector3(1,0.1,1)
	#print(direction.y)
	#print(is_on_floor())
	#print(player.position.y-destination.y)
	#print(navigation_agent_3d.distance_to_target())
	if direction.y < -0.7 and is_on_floor() and player.position.y-destination.y>-1.5 and (navigation_agent_3d.get_next_path_position()==navigation_agent_3d.get_final_position() or (navigation_agent_3d.is_target_reachable()==false and navigation_agent_3d.distance_to_target()<5)):
		velocity.y+=JUMP_VELOCITY
		# tu moze byc dzwiek
	if navigation_agent_3d.distance_to_target() > music.max_distance:
		music.stop()
	if navigation_agent_3d.distance_to_target() < music.max_distance and !music.playing:
		music.play()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	$Sprite3D.look_at(player.position+Vector3(0,3,0))
	#if navigation_agent_3d.get_next_path_position().y > global_position.y-0.78:
		#velocity.y+=2
	move_and_slide()

func _touched(body: Node3D):
	if body == player:
		self.position = Vector3(0,2,0)
		velocity = Vector3.ZERO
