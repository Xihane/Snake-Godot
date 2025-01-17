extends CharacterBody2D

var snake = [[5, 5]]
var snake_speed = 1
var snake_size = snake.size()

var snake_sprites = []

var directions = {
	"UP": Vector2(0, -1),
	"DOWN": Vector2(0, 1),
	"LEFT": Vector2(-1, 0),
	"RIGHT": Vector2(1, 0)
}            
var current_direction = "RIGHT"
var last_position = []

@onready var act_time = get_node("ActualizationTimer")
@onready var sprite = $Sprite2D
@onready var coll_area = $Area2D/CollisionShape2D

func _ready():
	snake_sprites.append(sprite)
	
	
	if act_time:
		act_time.start(0.1) # inicio el timer
		print("[Timer Iniciado]")
	else:
		print("Error: Timer no asignado")
	
	if not sprite:
		print("Error: Sprite no asignado")

func _input(event):
	if event.is_action_pressed("right") and current_direction != "LEFT":
		current_direction = "RIGHT"
	elif event.is_action_pressed("left") and current_direction != "RIGHT":
		current_direction = "LEFT"
	elif event.is_action_pressed("up") and current_direction != "DOWN":
		current_direction = "UP"
	elif event.is_action_pressed("down") and current_direction != "UP":
		current_direction = "DOWN"

func _on_actualization_timer_timeout():
	# Actualiza segmentos de la serpiente antes de mover la cabeza
	if snake.size() > 1:
		for section in range(snake.size() - 1, 0, -1):
			snake[section] = snake[section - 1]
			snake_sprites[section].position = snake_sprites[section - 1].position
			print("SECTION: [", section, snake[section], "]")

	# Mueve la cabeza de la serpiente
	var snake_head = Vector2(snake[0][0], snake[0][1])
	snake_head += directions[current_direction] * snake_speed
	snake_head.x = clamp(snake_head.x, 0, Global.GRID_SIZE_X - 1)
	snake_head.y = clamp(snake_head.y, 0, Global.GRID_SIZE_Y - 1)
	
	snake[0] = [snake_head.x, snake_head.y]
	snake_sprites[0].position = snake_head * Global.scale
	coll_area.position = snake_head * Global.scale
	
	print("HEAD-POSS: [", snake[0], "]")


func snake_grow():
	print("[GROWING]")
	
	var new_segment_position = snake[snake.size() - 1]
	snake.append(new_segment_position) # se agregan las coordenadas del ultimo segmento
	
	var new_sprite = Sprite2D.new() # nuevo sprite2d y ajustes
	new_sprite.texture = preload("res://images/4061.png")
	new_sprite.set_region_enabled(true)
	new_sprite.region_rect = sprite.get_region_rect()
	add_child(new_sprite) # añadimos a la escena el nuevo sprite
	snake_sprites.append(new_sprite) # agregamos el sprite a la lista de sprites
	
	print("\n[GROW FINISHED]")
	print("SIZE: [",snake.size(),"]")


func _on_area_2d_area_entered(area):
	print("[CONTACT]")
	if area.get_parent().is_in_group("colectable"):
		snake_grow()
