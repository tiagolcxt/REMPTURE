extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_SPEED: int = -1600
const BASE_SPEED: float = 0.0

@export var knockback_distance := 100
@export var invulnerable_time := 1.5
@export var blink_interval := 0.1

@onready var combustivel_manager = get_parent().get_node("CombustivelManager")
@onready var animated_sprite = $AnimatedSprite2D
@onready var camera := get_viewport().get_camera_2d()

var is_invulnerable := false
var blink_timer := 0.0
var invulnerable_timer := 1.5
var is_ducking := false

func _ready():
	animated_sprite.sprite_frames = load("res://animations/walk_animation.tres")
	animated_sprite.play("walk")

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta

	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			jump()
		#elif Input.is_action_pressed("ui_down"):
			#duck()
		else:
			if not is_ducking:
				animated_sprite.play("walk")
	else:
		if animated_sprite.sprite_frames.has_animation("jump"):
			animated_sprite.play("jump")

	var combustivel_atual: float = combustivel_manager.combustivel
	var velocidade_horizontal: float = BASE_SPEED

	# Calcula a posição do personagem relativa à tela
	var pos_na_tela = position - camera.get_global_transform().origin + get_viewport_rect().size / 2

	# Movimento baseado no combustível e posição na tela (limite de 500px à direita)
	if combustivel_atual > 700.0 and pos_na_tela.x < 500.0:
		velocidade_horizontal = BASE_SPEED + (combustivel_atual - 700) / 25.0
	elif combustivel_atual < 300.0:
		velocidade_horizontal = BASE_SPEED - (300 - combustivel_atual) / 25.0

	velocity.x = velocidade_horizontal
	move_and_slide()

	if is_on_floor() and not is_ducking:
		animated_sprite.speed_scale = 1.0 + (velocidade_horizontal - BASE_SPEED) / 100.0

func jump() -> void:
	velocity.y = JUMP_SPEED
	if animated_sprite.sprite_frames.has_animation("jump"):
		animated_sprite.play("jump")

func duck() -> void:
	is_ducking = true
	$RunningCollision.disabled = true
	if animated_sprite.sprite_frames.has_animation("duck"):
		animated_sprite.play("duck")
	else:
		animated_sprite.stop()

func _process(delta: float) -> void:
	if is_invulnerable:
		invulnerable_timer -= delta
		blink_timer -= delta
		if blink_timer <= 0.0:
			animated_sprite.modulate.a = 1.0 if animated_sprite.modulate.a < 0.5 else 0.2
			blink_timer = blink_interval
		if invulnerable_timer <= 0.0:
			animated_sprite.modulate.a = 1.0
			is_invulnerable = false
	elif is_on_floor() and not is_ducking and not animated_sprite.is_playing():
		animated_sprite.play("walk")

func adicionar_combustivel(valor: float) -> void:
	combustivel_manager.adicionar_combustivel(valor)
