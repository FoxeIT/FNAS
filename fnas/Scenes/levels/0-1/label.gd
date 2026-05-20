extends Label
var dir = Vector2(1,1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(200,200)*dir*delta
	if position.x + size.x > 920:
		dir.x = -1
	if position.y + size.y > 520:
		dir.y = -1
	if position.y < 0:
		dir.y = 1
	if position.x < 0:
		dir.x = 1
