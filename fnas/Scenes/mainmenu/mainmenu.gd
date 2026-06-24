extends Control

onready var new_game: Button = $BoxContainer/NewGame
onready var exit_btn: Button = $BoxContainer/Button

var _menu_ready := false

func _ready():
	var logo = $StudioLogo
	if logo and logo.has_node("AnimationPlayer"):
		var animator: AnimationPlayer = logo.get_node("AnimationPlayer")
		if not animator.is_connected("animation_finished", self, "_on_intro_finished"):
			animator.connect("animation_finished", self, "_on_intro_finished")

func _on_intro_finished(_anim_name: String):
	_menu_ready = true
	new_game.focus_neighbour_bottom = new_game.get_path_to(exit_btn)
	exit_btn.focus_neighbour_top = exit_btn.get_path_to(new_game)

func _input(event: InputEvent):
	if event is InputEventMouseMotion or (event is InputEventMouseButton and event.pressed):
		if new_game.has_focus() or exit_btn.has_focus():
			new_game.release_focus()
	if not _menu_ready:
		return
	if event is InputEventJoypadButton and event.pressed:
		if not new_game.has_focus() and not exit_btn.has_focus():
			new_game.grab_focus()
	if event is InputEventJoypadMotion and abs(event.axis_value) > 0.15:
		if not new_game.has_focus() and not exit_btn.has_focus():
			new_game.grab_focus()
