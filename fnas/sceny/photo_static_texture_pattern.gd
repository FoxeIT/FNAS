extends Sprite2D

var initPos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initPos = self.position # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = initPos + Vector2(randi_range(-100, 100), randi_range(-100, 100))
