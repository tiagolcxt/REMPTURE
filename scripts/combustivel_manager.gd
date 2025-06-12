extends Node

@export var max_combustivel := 1000
@export var combustivel := 1000
@export var consumo_por_segundo := 2

signal combustivel_alterado(valor)

func consumir_combustivel(delta: float) -> void:
	if combustivel > 0:
		combustivel -= consumo_por_segundo * delta
		combustivel = max(0, combustivel)
		combustivel_alterado.emit(combustivel)

func adicionar_combustivel(valor: float) -> void:
	combustivel = clamp(combustivel + valor, 0, max_combustivel)
	combustivel_alterado.emit(combustivel)

func remover_combustivel(valor: float) -> void:
	combustivel = max(0, combustivel - valor)
	combustivel_alterado.emit(combustivel)
