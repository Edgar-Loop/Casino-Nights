extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var menu_buttons: CanvasLayer = $AnimatedSprite2D/MenuButtons

func _ready() -> void:
	menu_buttons.hide()
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)
	animated_sprite_2d.play("Intro")

func _process(delta: float) -> void:
	pass

func _on_animation_finished() -> void:
	if animated_sprite_2d.animation == "Intro":
		menu_buttons.show()
