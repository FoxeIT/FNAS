extends SpotLight3D

@onready var sub_viewport: SubViewport = $"../../../SubViewport"
@onready var sprite_2d: Sprite2D = $"../Sprite2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var color := Vector3.ZERO
	var texture_size := sprite_2d.texture.get_size()
	var image := sprite_2d.texture.get_image()
	
	for y in range(0, texture_size.y):
		for x in range(0, texture_size.x):
			var pixel := image.get_pixel(x, y)
			color += Vector3(pixel.r, pixel.g, pixel.b)
			
	color /= texture_size.x * texture_size.y

	self.light_color = Color(color.x, color.y, color.z)
