extends Node2D

@onready var player = get_parent().get_node("Player")
@onready var camera = get_parent().get_node("Camera2D")
@onready var sprite: Sprite2D = $Sprite2D

var wave_timer: float = 0.0
var alpha_direction: int = 1
var current_alpha: float = Globals.GHOST_MIN_ALPHA

func _ready():
	position = Globals.GHOST_START_POSITION
	set_process(true)

func _process(delta):
	if player == null or camera == null:
		return

	# ⚠️ Verifica se o jogo já começou
	if not get_parent().game_running:
		return

	# 🎯 Posição alvo atrás da câmera (offset X constante)
	var target_x = camera.position.x + Globals.GHOST_X_OFFSET

	# 🧙‍♂️ Movimento senoidal no eixo Y
	wave_timer += delta * Globals.GHOST_WAVE_FREQUENCY
	var wave_y = sin(wave_timer) * Globals.GHOST_WAVE_AMPLITUDE
	var target_y = player.position.y + Globals.GHOST_Y_OFFSET + wave_y

	# 🌀 Interpolação suave da posição
	position.x = lerp(position.x, target_x, delta * Globals.GHOST_FOLLOW_SPEED)
	position.y = lerp(position.y, target_y, delta * Globals.GHOST_FOLLOW_SPEED)

	# 👻 Alternar alpha (transparência) suavemente
	current_alpha += Globals.GHOST_FADE_SPEED * delta * alpha_direction
	if current_alpha >= Globals.GHOST_MAX_ALPHA:
		current_alpha = Globals.GHOST_MAX_ALPHA
		alpha_direction = -1
	elif current_alpha <= Globals.GHOST_MIN_ALPHA:
		current_alpha = Globals.GHOST_MIN_ALPHA
		alpha_direction = 1

	# 🎨 Aplicar a transparência no sprite
	var color = sprite.modulate
	color.a = current_alpha
	sprite.modulate = color
