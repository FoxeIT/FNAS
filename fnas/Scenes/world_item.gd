extends Node3D

@export var p_name  : String = "Przedmiot"
@export var p_icon  : String = ""
@export var p_count : int    = 1
@export var p_held  : String = "res://Scenes/wordlitem_held.tscn"

@onready var interact_area : Area3D  = $InteractArea
@onready var prompt_label  : Label3D = $PromptLabel

var _player_nearby : bool = false

func _ready() -> void:
	prompt_label.text    = "E — podnieś " + p_name
	prompt_label.visible = false
	interact_area.body_entered.connect(_on_body_entered)
	interact_area.body_exited.connect(_on_body_exited)

func _input(event: InputEvent) -> void:
	if not _player_nearby:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		_pick_up()

func _pick_up() -> void:
	Inventory.add_item(p_name, p_icon, p_count, p_held)
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		_player_nearby       = true
		prompt_label.visible = true

func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D:
		_player_nearby       = false
		prompt_label.visible = false
