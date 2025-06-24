extends Node

@export var COMBUSTIVEL_SCENE: PackedScene = preload("res://scenes/combustivel.tscn")
var combustiveis: Array = []
var last_combustivel_x = 0

func generate_combustivel(score: int, screen_size: Vector2i, ground_y: int) -> Area2D:
	if combustiveis.is_empty() or last_combustivel_x < score + randi_range(500, 1200):
		var c = COMBUSTIVEL_SCENE.instantiate()
		var sprite = c.get_node("Sprite2D")
		var c_height = sprite.texture.get_height()
		var c_scale = sprite.scale
		var x = screen_size.x + score + randi_range(200, 1000)
		var y = ground_y - (c_height * c_scale.y / 2) + 365 + randi_range(-120, 100)

		c.position = Vector2i(x, y)

		# conectar sinal para remover da lista quando coletado
		c.connect("collected", Callable(self, "remove_combustivel"))

		combustiveis.append(c)
		last_combustivel_x = x
		return c
	return null

func remove_combustivel(c):
	if combustiveis.has(c):
		combustiveis.erase(c)
		c.queue_free()

func clear_all():
	for c in combustiveis:
		c.queue_free()
	combustiveis.clear()
