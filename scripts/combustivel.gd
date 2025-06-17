extends Area2D

signal collected

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
	if body.name == "Player":
		print("Combustível coletado!")
		body.adicionar_combustivel(100)  # Valor de combustível a ser adicionado
		emit_signal("collected", self)
		queue_free()
