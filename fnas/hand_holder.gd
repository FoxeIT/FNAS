extends Node3D

func _ready() -> void:
	add_to_group("hand_holder")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("drop_item"):
		_drop()

func _drop() -> void:
	if get_child_count() == 0:
		return
	for child in get_children():
		child.queue_free()
	print("Odlozono przedmiot")
