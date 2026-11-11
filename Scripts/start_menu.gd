extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var menu_buttons: CanvasLayer = $AnimatedSprite2D/MenuButtons
@onready var dialogue: Node2D = $Dialogue
@onready var dialogue_text: Label = $Dialogue/DialogueText

@onready var play: Button = $AnimatedSprite2D/MenuButtons/Play
@onready var settings: Button = $AnimatedSprite2D/MenuButtons/Settings
@onready var quit: Button = $AnimatedSprite2D/MenuButtons/Quit

var dialogue_lines: Array[String] = [
	"Mr. A (Phone): Hello? You there?",
	"Player: Yeah. I'm listening.",
	"Mr. A: Good. I assume you remember why you're doing this.",
	"Player: I remember. My daughter needs help, and I need the money.",
	"Mr. A: Exactly. And I've got something that might solve your problem.",
	"Player: What is it?",
	"Mr. A: There's a place nearby with a hidden money vault. It's supposed to hold a fortune.",
	"Player: A vault? How am I supposed to find it?",
	"Mr. A: That's what you'll have to figure out once you're inside. I don't have all the details.",
	"Player: You better not be wasting my time, Mr. A.",
	"Mr. A: I'm not. But listen carefully. This place isn't as empty as it looks.",
	"Player: What do you mean?",
	"Mr. A: There are security robots patrolling the building. You'll need to be careful.",
	"Player: Robots? You left that part out.",
	"Mr. A: I thought you'd want to know before going in. Anyway, the money is your priority.",
	"Player: I'm doing this for my daughter. I can't afford to fail.",
	"Mr. A: Then find that vault. I'll be waiting for your call."
]

var current_line: int = 0
var dialogue_active: bool = false

func _ready() -> void:
	dialogue.hide()
	menu_buttons.hide()

	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	play.pressed.connect(_on_play_pressed)
	settings.pressed.connect(_on_settings_pressed)
	quit.pressed.connect(_on_quit_pressed)

	animated_sprite_2d.play("Intro")

func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "Intro":
		menu_buttons.show()

func _on_play_pressed() -> void:
	menu_buttons.hide()
	dialogue.show()

	current_line = 0
	dialogue_active = true
	show_dialogue_line()

func show_dialogue_line() -> void:
	if current_line < dialogue_lines.size():
		dialogue_text.text = dialogue_lines[current_line]
	else:
		dialogue_active = false
		dialogue.hide()
		get_tree().change_scene_to_file("res://Scenes/prototype.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if dialogue_active and event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			current_line += 1
			show_dialogue_line()

	if dialogue_active and event is InputEventScreenTouch:
		if event.pressed:
			current_line += 1
			show_dialogue_line()

func _on_settings_pressed() -> void:
	print("open settings")

func _on_quit_pressed() -> void:
	get_tree().quit()
