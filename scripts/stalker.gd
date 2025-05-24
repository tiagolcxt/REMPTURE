extends CharacterBody2D

@export var target: NodePath  # Caminho para o Player
@export var follow_distance: float = 300.0  # Distância horizontal desejada
@export var wave_amplitude: float = 20.0  # Altura do movimento ondulatório
@export var wave_speed: float = 2.0  # Velocidade do movimento ondulatório
@export var follow_speed: float = 150.0  # Velocidade com que ajusta a posição

var time := 0.0
var player: Node2D

func _ready():
	player = get_node(target)

func _physics_process(delta):
	if not player:
		return

	time += delta

	# Posição desejada (x) — mantenha uma distância atrás do player
	var target_x = player.global_position.x - follow_distance

	# Suavemente aproxima-se do target_x com follow_speed
	var new_x = lerp(global_position.x, target_x, follow_speed * delta / follow_distance)

	# Movimento vertical ondulatório (fantasmagórico)
	var wave_offset = sin(time * wave_speed) * wave_amplitude
	var new_y = player.global_position.y + wave_offset

	global_position = Vector2(new_x, new_y)
