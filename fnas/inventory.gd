extends Node

var items: Array = []

signal inventory_changed

func add_item(p_name: String, p_icon: String = "", p_count: int = 1, p_held: String = "") -> void:
	for item in items:
		if item["n"] == p_name:
			item["c"] += p_count
			inventory_changed.emit()
			return
	items.append({ "n": p_name, "i": p_icon, "c": p_count, "h": p_held })
	inventory_changed.emit()

func remove_item(p_name: String, p_count: int = 1) -> void:
	for item in items:
		if item["n"] == p_name:
			item["c"] -= p_count
			if item["c"] <= 0:
				items.erase(item)
			inventory_changed.emit()
			return

func has_item(p_name: String) -> bool:
	for item in items:
		if item["n"] == p_name:
			return true
	return false

func get_held_scene(p_name: String) -> String:
	for item in items:
		if item["n"] == p_name:
			return item["h"]
	return ""
