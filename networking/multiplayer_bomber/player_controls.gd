extends Node

## Lokale Variable für die Bewegungssynchronisation
@export var motion := Vector2():
	set(value):
		# This will be sent by players, make sure values are within limits.
		motion = clamp(value, Vector2(-1, -1), Vector2(1, 1))

@export var bombing := false

func update() -> void:
	motion = Vector2()
	if Input.is_action_pressed(&"move_left"):
		motion += Vector2(-1, 0)
	if Input.is_action_pressed(&"move_right"):
		motion += Vector2(1, 0)
	if Input.is_action_pressed(&"move_up"):
		motion += Vector2(0, -1)
	if Input.is_action_pressed(&"move_down"):
		motion += Vector2(0, 1)

	bombing = Input.is_action_pressed(&"set_bomb")
