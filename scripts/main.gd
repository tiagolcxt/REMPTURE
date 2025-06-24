extends Node

var GLOBALS = Globals.new()
var obstacles = Obstacles.new()
var combustiveis_controller = preload("res://scripts/combustiveis.gd").new()
var hud: Hud
@onready var combustivel_manager = $CombustivelManager
@onready var sopro_continuo = $SoproContinuo
@onready var ghost_sound = $GhostSound
@onready var thunder_sound = $ThunderSound
@onready var bell_sound = $BellSound
@onready var internal_decorations = get_node_or_null("ParallaxBackground/InternalDecorationsContainer")

var screen_size: Vector2i
var ground_height: int

var game_running: bool = false
var aguardando_inicio: bool = true
var difficulty: int = 0

var speed: float = 0.0
var score: int = 0
var high_score: int = 0

var proximo_sopro_score: int = 6000
var ultimo_ghost_sound_score: int = -800
var proximo_thunder_score: int = 0

var last_decoration_spawn_score: int = 0
var decoration_spawn_interval: int = 3000  # Intervalo entre spawns de decoração

func _ready():
	hud = Hud.new($HUD)
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(start_new_game)
	get_tree().paused = false
	
	if is_instance_valid(internal_decorations):
		print("[MAIN] InternalDecorationsContainer encontrado com sucesso")
		internal_decorations.clear_all_decorations()
	else:
		printerr("[MAIN] InternalDecorationsContainer não encontrado! Verifique o caminho.")
	
	start_new_game()

func _process(delta):
	hud.show_combustivel(int(combustivel_manager.combustivel))
	hud.show_score(score)

	consumir_combustivel_se_jogo_rodando(delta)
	
	if is_instance_valid(internal_decorations) and game_running:
		internal_decorations.spawn_all_decorations(score)
		# Verifica se é hora de spawnar novas decorações
		if game_running and score - last_decoration_spawn_score > decoration_spawn_interval:
			print("[MAIN] Tentando spawnar decorações no score: ", score)
			internal_decorations.spawn_all_decorations(score)
			last_decoration_spawn_score = score
			print("[MAIN] Decorações spawnadas. Próximo spawn em: ", score + decoration_spawn_interval)

	if game_running and not aguardando_inicio:
		speed = min(GLOBALS.START_SPEED + score / GLOBALS.SPEED_MODIFIER, GLOBALS.MAX_SPEED)
		difficulty = min(score / GLOBALS.SPEED_MODIFIER, GLOBALS.MAX_DIFFICULTY)

		generate_obstacles()
		generate_combustivel()

		$Player.position.x += speed
		$Camera2D.position.x += speed
	
		score += speed
		
		if is_instance_valid(internal_decorations):
			internal_decorations.update_decorations($Camera2D.global_position, screen_size)
		
		if score >= proximo_sopro_score:
			if sopro_continuo and not sopro_continuo.playing:
				sopro_continuo.play()
			proximo_sopro_score += 12000

		if combustivel_manager.combustivel < 300 and (score - ultimo_ghost_sound_score) >= 800:
			if ghost_sound and not ghost_sound.playing:
				ghost_sound.play()
				ultimo_ghost_sound_score = score

		if score >= proximo_thunder_score:
			if thunder_sound and not thunder_sound.playing:
				thunder_sound.play()
				proximo_thunder_score = score + randi_range(5000, 12000)

		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x

		for obstacle in obstacles.spawned_obstacles:
			if is_instance_valid(obstacle) and obstacle.position.x < ($Camera2D.position.x - screen_size.x):
				obstacles.remove_obstacle(obstacle)

		for c in combustiveis_controller.combustiveis.duplicate():
			if is_instance_valid(c) and c.position.x < ($Camera2D.position.x - screen_size.x):
				combustiveis_controller.remove_combustivel(c)
	else:
		if aguardando_inicio and Input.is_action_just_pressed("ui_accept"):
			game_running = true
			aguardando_inicio = false
			hud.hide_start_hud()

func consumir_combustivel_se_jogo_rodando(delta):
	if game_running and not aguardando_inicio:
		combustivel_manager.consumir_combustivel(delta)

func start_new_game():
	print("[MAIN] Iniciando novo jogo")
	score = 0
	difficulty = 0
	game_running = false
	aguardando_inicio = true
	if is_instance_valid(internal_decorations):
		internal_decorations.reset_spawn_system()
	proximo_sopro_score = 600
	ultimo_ghost_sound_score = -800
	proximo_thunder_score = randi_range(3000, 8000)
	last_decoration_spawn_score = 0
	get_tree().paused = false

	combustivel_manager.combustivel = combustivel_manager.max_combustivel
	obstacles.clear_all_spawned_obstacles()
	combustiveis_controller.clear_all()
	
	if is_instance_valid(internal_decorations):
		print("[MAIN] Limpando decorações para novo jogo")
		internal_decorations.clear_all_decorations()
	
	reset_scenes()

	hud.show_score(score)
	hud.show_start_hud()
	$GameOver.hide()

func reset_scenes():
	$Player.position = GLOBALS.CHARACTER_START_POSITION
	$Player.velocity = Vector2i(0, 0)
	$Ghost.position = GLOBALS.GHOST_START_POSITION
	$Camera2D.position = GLOBALS.CAMERA_START_POSITION
	$Ground.position = Vector2i(0, 0)
	combustiveis_controller.last_combustivel_x = 0

func update_high_score():
	if score > high_score:
		high_score = score
		hud.show_high_score(high_score)

func generate_obstacles():
	if not obstacles.spawned_obstacles.is_empty():
		var last_obstacle_x = obstacles.last_spawned_obstactle.position.x
		if last_obstacle_x > score - randi_range(800, 1200):
			return

	var obstacle_type = obstacles.get_random_obstacle_type()
	var max_obstacles = min(difficulty + 1, 2)
	var ground_y = $Ground.position.y

	for i in range(randi() % max_obstacles + 1):
		var obstacle = obstacle_type.instantiate()
		var sprite = obstacle.get_node("Sprite2D")
		var obstacle_height = sprite.texture.get_height()
		var obstacle_scale = sprite.scale

		var obstacle_x = screen_size.x + score + 500 + (i * 100)
		var obstacle_y = ground_y - (obstacle_height * obstacle_scale.y / 2) + 565

		obstacles.last_spawned_obstactle = obstacle
		add_obstacle(obstacle, obstacle_x, obstacle_y)

	if difficulty == GLOBALS.MAX_DIFFICULTY and (randi() % 4) == 0:
		var obstacle = obstacles.BIRD_SCENE.instantiate()
		var obstacle_x = screen_size.x + score + 800
		var obstacle_y = obstacles.get_random_bird_spawn_height()
		add_obstacle(obstacle, obstacle_x, obstacle_y)

func add_obstacle(obstacle, x, y):
	obstacle.position = Vector2i(x, y)
	obstacle.body_entered.connect(hit_obstacle)
	add_child(obstacle)
	obstacles.spawned_obstacles.append(obstacle)

func hit_obstacle(body):
	if body.name == "Player" and not body.is_invulnerable:
		$CharacterHurt.play()
		combustivel_manager.remover_combustivel(100.0)
		body.position.x -= body.knockback_distance
		body.is_invulnerable = true
		body.invulnerable_timer = body.invulnerable_time
		body.blink_timer = body.blink_interval

func game_over():
	update_high_score()
	
	if is_instance_valid(bell_sound):
		bell_sound.play()
	
	# Troca de cena de forma segura com call_deferred()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/interface/morte.tscn")
	

func generate_combustivel():
	var c = combustiveis_controller.generate_combustivel(score, screen_size, $Ground.position.y)
	if c:
		add_child(c)
