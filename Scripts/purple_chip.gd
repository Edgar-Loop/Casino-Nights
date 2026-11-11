extends Area2D




func _on_body_entered(body):
	print("+1 Chip")
	queue_free()
