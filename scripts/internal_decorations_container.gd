extends Node2D
class_name InternalDecorationsContainer

const DECORATION_SCENES := {
	"quadro": preload("res://scenes/quadro.tscn"),
	"gato": preload("res://scenes/gato.tscn")
}

const MIN_SPAWN_INTERVAL := 1200
const MAX_SPAWN_INTERVAL := 4000
const BASE_SPAWN_CHANCE := 0.4
const SCORE_SPAWN_INCREMENT := 0.0002
const MAX_SPAWN_CHANCE := 0.8

var parallax_layer_intern: ParallaxLayer
var sprite2d2: Sprite2D
var spawned_decorations: Array = []
var next_spawn_at_score := 0
var debug_enabled := true

func _ready() -> void:
	parallax_layer_intern = get_parent().get_node("ParallaxLayer_intern")
	sprite2d2 = parallax_layer_intern.get_node("Sprite2D2")

	if debug_enabled:
		print("[DEBUG] Sistema inicializado. Próximo spawn em: ", next_spawn_at_score)
		print("Referência ParallaxLayer: ", parallax_layer_intern != null)
		print("Referência Sprite2D2: ", sprite2d2 != null)

func reset_spawn_system() -> void:
	clear_all_decorations()
	next_spawn_at_score = randi_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL)

func spawn_all_decorations(current_score: int) -> void:
	if current_score < next_spawn_at_score:
		return

	var spawn_chance = min(BASE_SPAWN_CHANCE + (current_score * SCORE_SPAWN_INCREMENT), MAX_SPAWN_CHANCE)
	next_spawn_at_score = current_score + randi_range(MIN_SPAWN_INTERVAL, MAX_SPAWN_INTERVAL)

	if randf() > spawn_chance:
		return

	# Procurar markers filhos do Sprite2D2
	var markers = sprite2d2.get_children().filter(func(c): return c is Marker2D)
	if markers.is_empty():
		printerr("[ERRO] Nenhum Marker2D encontrado dentro do Sprite2D2!")
		return

	markers.shuffle()

	for i in range(randi_range(1, markers.size())):
		var marker = markers[i]
		var decoration_type = "quadro" if marker.name == "Marker2D2" else "gato"

		if not DECORATION_SCENES.has(decoration_type):
			continue

		var decoration = DECORATION_SCENES[decoration_type].instantiate()
		decoration.position = marker.position  # Posição local em relação ao Sprite2D2
		sprite2d2.add_child(decoration)  # Adiciona como filho do Sprite2D2
		spawned_decorations.append(decoration)

		if debug_enabled:
			print("[DEBUG] Decoração spawnada: ", decoration.name, " em ", decoration.position)
func update_decorations(camera_position: Vector2, screen_size: Vector2) -> void:
	for decoration in spawned_decorations.duplicate():
		if not is_instance_valid(decoration):
			spawned_decorations.erase(decoration)
			continue

		var decoration_global_x = decoration.get_global_position().x
		var camera_left_limit = camera_position.x - (screen_size.x )/2
		
		if decoration_global_x < camera_left_limit - 10000:
			decoration.queue_free()
			spawned_decorations.erase(decoration)

			if debug_enabled:
				print("[DEBUG] Decoração liberada fora da câmera: ", decoration.name)

func clear_all_decorations() -> void:
	for decoration in spawned_decorations:
		if is_instance_valid(decoration):
			decoration.queue_free()
	spawned_decorations.clear()
