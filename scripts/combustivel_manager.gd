extends Node

@export var max_combustivel := 1000
@export var combustivel := 1000
@export var consumo_por_segundo := 2

signal combustivel_alterado(valor)

@onready var player_light = get_node("/root/Main/Player/PointLight2D")

func consumir_combustivel(delta: float) -> void:
	if combustivel > 0:
		combustivel -= consumo_por_segundo * delta
		combustivel = max(0, combustivel)

	combustivel_alterado.emit(combustivel)
	atualizar_luz()

func adicionar_combustivel(valor: float) -> void:
	combustivel = clamp(combustivel + valor, 0, max_combustivel)
	combustivel_alterado.emit(combustivel)
	atualizar_luz()

func remover_combustivel(valor: float) -> void:
	combustivel = max(0, combustivel - valor)
	combustivel_alterado.emit(combustivel)
	atualizar_luz()

func atualizar_luz() -> void:
	if not player_light:
		return

	var proporcao: float = float(combustivel) / float(max_combustivel)
	var min_scale := 0.2
	var max_scale := 0.8
	var nova_escala: float = lerp(min_scale, max_scale, proporcao)
	player_light.texture_scale = nova_escala
