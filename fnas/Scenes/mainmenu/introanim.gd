extends Node2D

var animator: AnimationPlayer
var colorRect: ColorRect
var logo: Sprite2D
var text1: RichTextLabel
var text2: RichTextLabel
var audioBus: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator = get_node("AnimationPlayer")
	colorRect = get_node('ColorRect')
	logo = get_node("Logo")
	text1 = get_node("Text1")
	text2 = get_node("Text2")
	audioBus = AudioServer.get_bus_index("Master")
	
	#AudioServer.set_bus_volume_linear(audioBus, 0)
	animator.connect("animation_finished", _anim_done)
	animator.play("intro")

func _anim_done(_1):
	#AudioServer.set_bus_volume_linear(audioBus, 1)
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var size = get_viewport().get_visible_rect().size
	logo.position = size / 2
	text1.size = size
	text2.size = size
	colorRect.size = size
