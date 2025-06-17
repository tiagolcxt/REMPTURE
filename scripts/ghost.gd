extends Node2D

@onready var player = get_parent().get_node("Player")
@onready var camera = get_parent().get_node("Camera2D")
@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D

var wave_timer: float = 0.0
var alpha_direction: int = 1
var current_alpha: float = Globals.GHOST_MIN_ALPHA

func _ready():
	position = Vector2(camera.position.x + Globals.GHOST_X_OFFSET, Globals.GHOST_START_POSITION.y)
	
	if area.has_signal("body_entered"):
		area.connect("body_entered", Callable(self, "_on_body_entered"))
	else:
		push_error("Area2D não tem sinal 'body_entered' ou não foi encontrada corretamente.")

	set_process(true)

func _process(delta):
	if player == null or camera == null:
		return

	if not get_parent().game_running:
		return

	# Posição X fixa em relação à câmera (sem interpolação)
	position.x = camera.position.x + Globals.GHOST_X_OFFSET

	# Comportamento original no eixo Y:
	# Movimento senoidal no eixo Y
	wave_timer += delta * Globals.GHOST_WAVE_FREQUENCY
	var wave_y = sin(wave_timer) * Globals.GHOST_WAVE_AMPLITUDE
	var target_y = player.position.y + Globals.GHOST_Y_OFFSET + wave_y

	# Interpolação suave apenas no eixo Y
	position.y = lerp(position.y, target_y, delta * Globals.GHOST_FOLLOW_SPEED)

	# Efeito de fade in/out
	current_alpha += Globals.GHOST_FADE_SPEED * delta * alpha_direction
	if current_alpha >= Globals.GHOST_MAX_ALPHA:
		current_alpha = Globals.GHOST_MAX_ALPHA
		alpha_direction = -1
	elif current_alpha <= Globals.GHOST_MIN_ALPHA:
		current_alpha = Globals.GHOST_MIN_ALPHA
		alpha_direction = 1

	# Aplica a cor e transparência
	var base_color = Color(0.8, 0.8, 0.8, 1.0)
	base_color.a = current_alpha
	sprite.modulate = base_color

func _on_body_entered(body):
	if body.name == "Player" or body is CharacterBody2D:
		print("Player colidiu com o Ghost!")
		get_parent().game_over()
