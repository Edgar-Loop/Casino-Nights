extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var menu_buttons: CanvasLayer = $AnimatedSprite2D/MenuButtons

@onready var play: Button = $AnimatedSprite2D/MenuButtons/Play
@onready var settings: Button = $AnimatedSprite2D/MenuButtons/Settings
@onready var quit: Button = $AnimatedSprite2D/MenuButtons/Quit

func _ready() -> void:
	menu_buttons.hide()
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	play.pressed.connect(_on_play_pressed)
	settings.pressed.connect(_on_settings_pressed)
	quit.pressed.connect(_on_quit_pressed)
	animated_sprite_2d.play("Intro")

func _process(delta: float) -> void:
	pass

func _on_animation_finished():
	if animated_sprite_2d.animation == "Intro":
		menu_buttons.show()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/prototype.tscn")

func _on_settings_pressed():
	print("open settings")
	
func _on_quit_pressed():
	get_tree().quit()
