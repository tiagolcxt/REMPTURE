extends TextureProgressBar

@export var combustivel_manager: NodePath
@export var cor_normal := Color(0.2, 0.8, 0.2)  # Verde
@export var cor_baixo := Color(0.8, 0.2, 0.2)   # Vermelho
@export var tempo_transicao := 0.3

var _combustivel_manager: Node

func _ready():
	if combustivel_manager:
		_combustivel_manager = get_node(combustivel_manager)
		_combustivel_manager.combustivel_alterado.connect(_atualizar_barra)
		
		# Configura valores iniciais
		max_value = _combustivel_manager.max_combustivel
		value = _combustivel_manager.combustivel
		tint_progress = cor_normal

func _atualizar_barra(valor_atual: float):
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	
	# Animação do valor
	tween.tween_property(self, "value", valor_atual, tempo_transicao)
	
	# Transição de cor quando abaixo de 30%
	if valor_atual < max_value * 0.3:
		var intensidade = 1.0 - (valor_atual / (max_value * 0.3))  # Gradiente de 0 a 1
		var cor_interpolada = cor_normal.lerp(cor_baixo, intensidade)
		tween.parallel().tween_property(self, "tint_progress", cor_interpolada, tempo_transicao)
	else:
		tween.parallel().tween_property(self, "tint_progress", cor_normal, tempo_transicao)
