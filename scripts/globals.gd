class_name Globals

# Constantes gerais do jogo
const CHARACTER_START_POSITION := Vector2i(500, 486)
const CAMERA_START_POSITION := Vector2i(576, 324)

const SCORE_MODIFIER: int = 10
const SPEED_MODIFIER: int = 5000

const START_SPEED: float = 10.0
const MAX_SPEED: int = 15
const MAX_DIFFICULTY: int = 3

# Constantes específicas para o Ghost
const GHOST_START_POSITION := Vector2i(100, 386)  # Posição inicial do fantasma
const GHOST_X_OFFSET := -300  # Distância padrão atrás da câmera
const GHOST_Y_OFFSET := -50.0  # Altura base em relação ao chão

const GHOST_WAVE_AMPLITUDE := 20.0  # Altura da onda de flutuação
const GHOST_WAVE_FREQUENCY := 2.0  # Velocidade da onda
const GHOST_FOLLOW_SPEED := 2.0  # Suavização do movimento

const GHOST_FADE_SPEED := 0.5  # Velocidade do efeito de aparecer/desaparecer
const GHOST_MIN_ALPHA := 0.5  # Transparência mínima
const GHOST_MAX_ALPHA := 1.0  # Transparência máxima

# Dificuldade do Ghost
const GHOST_SPEED_MULTIPLIERS := [0.8, 1.0, 1.2, 1.5]  # Multiplicadores por nível
