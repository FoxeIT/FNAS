extends Control

@onready var item_list : VBoxContainer = $Panel/ItemList

var _hand_holder : Node3D = null

func _ready() -> void:
	visible = false
	Inventory.inventory_changed.connect(_refresh)

func _find_hand_holder() -> void:
	# Szuka HandHolder w całej scenie po nazwie
	_hand_holder = get_tree().get_root().find_child("HandHolder", true, false)
	if _hand_holder == null:
		push_error("Nie znaleziono HandHolder! Upewnij sie ze wezel nazywa sie dokladnie 'HandHolder'")
	else:
		print("HandHolder znaleziony: ", _hand_holder.get_path())

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_I:
		visible = !visible
		if visible:
			_find_hand_holder()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			_refresh()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _refresh() -> void:
	for child in item_list.get_children():
		child.queue_free()

	for i in range(Inventory.items.size()):
		var dict    = Inventory.items[i]
		var p_name  : String = str(dict.get("n", "???"))
		var p_icon  : String = str(dict.get("i", ""))
		var p_count : int    = int(dict.get("c", 1))
		var p_held  : String = str(dict.get("h", "res://Scenes/wordlitem_held.tscn"))

		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)

		# Ikonka
		var tex := TextureRect.new()
		tex.custom_minimum_size = Vector2(40, 40)
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		if p_icon != "":
			tex.texture = load(p_icon)
		row.add_child(tex)

		# Nazwa x licznik
		var lbl := Label.new()
		lbl.text = p_name + "   x" + str(p_count)
		lbl.add_theme_font_size_override("font_size", 18)
		lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(lbl)

		# Przycisk trzymaj
		if p_held != "":
			var btn := Button.new()
			btn.text = "Trzymaj"
			btn.pressed.connect(_equip_item.bind(p_name))
			row.add_child(btn)

		item_list.add_child(row)

func _equip_item(p_name: String) -> void:
	if _hand_holder == null:
		_find_hand_holder()
	if _hand_holder == null:
		return

	for child in _hand_holder.get_children():
		child.queue_free()

	var scene_path := Inventory.get_held_scene(p_name)
	if scene_path == "" or not ResourceLoader.exists(scene_path):
		push_error("Scena nie istnieje: " + scene_path)
		return

	var instance : Node = load(scene_path).instantiate()
	_hand_holder.add_child(instance)
	instance.owner = _hand_holder

	await get_tree().create_timer(0.1).timeout
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
