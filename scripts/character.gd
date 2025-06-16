extends CharacterBody2D

const GRAVITY: int = 4200
const JUMP_SPEED: int = -1600
const BASE_SPEED: float = 0.0

@export var knockback_distance := 100
@export var invulnerable_time := 1.5
@export var blink_interval := 0.1

@onready var combustivel_manager = get_parent().get_node("CombustivelManager")

var is_invulnerable := false
var blink_timer := 0.0
var invulnerable_timer := 0.0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta

	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			jump()
		elif Input.is_action_pressed("ui_down"):
			duck()

	var combustivel_atual: float = combustivel_manager.combustivel
	var velocidade_horizontal: float = BASE_SPEED # Sempre começa com a velocidade base

	# --- Lógica de variação da velocidade horizontal ---
	if combustivel_atual > 700.0 and position.x < Globals.CHARACTER_START_POSITION.x:
		# Combustível alto: velocidade_horizontal será BASE_SPEED + (0 a MAX_SPEED_BOOST)
	
		velocidade_horizontal = BASE_SPEED + (combustivel_atual - 700)/10
		
	elif combustivel_atual < 300.0:
		velocidade_horizontal = BASE_SPEED - (300 - combustivel_atual)/10
		
	# Para 300 <= combustivel_atual <= 700, velocidade_horizontal permanece como BASE_SPEED.
	
	# --- Aplica a velocidade calculada ---
	position.x += velocidade_horizontal * delta

	move_and_slide()

func jump() -> void:
	velocity.y = JUMP_SPEED

func duck() -> void:
	$RunningCollision.disabled = true

func _process(delta: float) -> void:
	if is_invulnerable:
		invulnerable_timer -= delta
		blink_timer -= delta
		if blink_timer <= 0.0:
			$Sprite2D.modulate.a = 1.0 if $Sprite2D.modulate.a < 0.5 else 0.2
			blink_timer = blink_interval
		if invulnerable_timer <= 0.0:
			$Sprite2D.modulate.a = 1.0
			is_invulnerable = false

func adicionar_combustivel(valor: float) -> void:
	combustivel_manager.adicionar_combustivel(valor)
