extends Node

var GLOBALS = Globals.new()
var obstacles = Obstacles.new()
var combustiveis_controller = preload("res://scripts/combustiveis.gd").new()
var hud: Hud
@onready var combustivel_manager = $CombustivelManager

var screen_size: Vector2i
var ground_height: int

var game_running: bool = false
var aguardando_inicio: bool = true
var difficulty: int = 0

var speed: float = 0.0
var score: int = 0
var high_score: int = 0

func _ready():
	hud = Hud.new($HUD)
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	$GameOver.get_node("Button").pressed.connect(start_new_game)
	get_tree().paused = false
	start_new_game()

func _process(delta):
	# Mostra sempre para debug
	hud.show_combustivel(int(combustivel_manager.combustivel))
	hud.show_score(score)
	
	# Debug: imprime o estado dos flags
	print("DEBUG -> game_running:", game_running, " aguardando_inicio:", aguardando_inicio)

	# Só consome combustível se o jogo estiver rodando e não estiver esperando start
	consumir_combustivel_se_jogo_rodando(delta)

	if game_running and not aguardando_inicio:
		speed = GLOBALS.START_SPEED

		difficulty = min(score / GLOBALS.SPEED_MODIFIER, GLOBALS.MAX_DIFFICULTY)

		generate_obstacles()
		generate_combustivel()

		$Player.position.x += speed
		$Camera2D.position.x += speed

		score += speed

		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x

		for obstacle in obstacles.spawned_obstacles:
			if obstacle.position.x < ($Camera2D.position.x - screen_size.x):
				obstacles.remove_obstacle(obstacle)

		for c in combustiveis_controller.combustiveis.duplicate():
			if is_instance_valid(c) and c.position.x < ($Camera2D.position.x - screen_size.x):
				combustiveis_controller.remove_combustivel(c)

	else:
		# Se estiver aguardando início, detectar input pra começar o jogo
		if aguardando_inicio and Input.is_action_just_pressed("ui_accept"):
			game_running = true
			aguardando_inicio = false
			hud.hide_start_hud()

func consumir_combustivel_se_jogo_rodando(delta):
	if game_running and not aguardando_inicio:
		combustivel_manager.consumir_combustivel(delta)
	else:
		# Aqui você pode usar para debug se quiser, por exemplo:
		# print("Consumo de combustível pausado: game_running =", game_running, ", aguardando_inicio =", aguardando_inicio)
		pass

func start_new_game():
	score = 0
	difficulty = 0
	game_running = false
	aguardando_inicio = true
	get_tree().paused = false

	combustivel_manager.combustivel = combustivel_manager.max_combustivel

	obstacles.clear_all_spawned_obstacles()
	combustiveis_controller.clear_all()

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
	if obstacles.spawned_obstacles.is_empty() or obstacles.last_spawned_obstactle.position.x < score + randi_range(200, 300):
		var obstacle_type = obstacles.get_random_obstacle_type()
		var obstacle
		var max_obstacles = 2
		var ground_y = $Ground.position.y

		for i in range(randi() % max_obstacles + 0):
			obstacle = obstacle_type.instantiate()
			var sprite = obstacle.get_node("Sprite2D")
			var obstacle_height = sprite.texture.get_height()
			var obstacle_scale = sprite.scale
			var random_spacing = randi_range(100, 400)
			var obstacle_x = screen_size.x + score + 50 + (i * random_spacing)
			var obstacle_y = ground_y - (obstacle_height * obstacle_scale.y / 2) + 565

			obstacles.last_spawned_obstactle = obstacle
			add_obstacle(obstacle, obstacle_x, obstacle_y)

		if difficulty == GLOBALS.MAX_DIFFICULTY and randi() % 2 == 0:
			obstacle = obstacles.BIRD_SCENE.instantiate()
			var obstacle_x = screen_size.x + score + 100
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
	get_tree().paused = true
	game_running = false
	$GameOver.show()

func generate_combustivel():
	var c = combustiveis_controller.generate_combustivel(score, screen_size, $Ground.position.y)
	if c:
		add_child(c)
