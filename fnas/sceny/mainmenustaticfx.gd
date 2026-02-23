extends VideoStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.size = get_viewport().get_visible_rect().size + Vector2(200, 200)
	self.position = Vector2(-100+randi_range(-100,100),-100+randi_range(-100,100))
