extends Node

@export var max_combustivel := 1000
@export var combustivel := 1000
@export var consumo_por_segundo := 2

signal combustivel_alterado(valor: float)

@onready var player_light1 = get_node("/root/Main/Player/Candle_light1")
@onready var player_light2 = get_node("/root/Main/Player/Candle_light2")
@onready var player_light3 = get_node("/root/Main/Player/Candle_light3")
@onready var coleta_de_luz = get_node("/root/Main/ColetaDeLuz")

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
	if coleta_de_luz:
		coleta_de_luz.pitch_scale = 1.3
		coleta_de_luz.play()

func remover_combustivel(valor: float) -> void:
	combustivel = max(0, combustivel - valor)
	combustivel_alterado.emit(combustivel)
	atualizar_luz()

func atualizar_luz() -> void:
	if not player_light1 and player_light2 and player_light3:
		return
	var proporcao1: float = float(combustivel) / float(max_combustivel)
	var proporcao2: float = float(combustivel) / float(700)
	var proporcao3: float = float(combustivel) / float(400)
	var min_scale1 := 0.0
	var max_scale1 := 0.1
	var min_scale2 := 0.0
	var max_scale2 := 0.4
	var min_scale3 := 0.0
	var max_scale3 := 0.7
	player_light1.texture_scale = lerp(min_scale1, max_scale1, proporcao1)
	player_light2.texture_scale = lerp(min_scale2, max_scale2, proporcao2)
	player_light3.texture_scale = lerp(min_scale3, max_scale3, proporcao3)
