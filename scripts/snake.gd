extends Node2D

var snake = [[0, 0]]
var snake_speed = 1

var directions = { 
	"UP": Vector2(0, -1),
	"DOWN": Vector2(0, 1),
	"LEFT": Vector2(-1,0),
	"RIGHT": Vector2(1,0)
}
var current_direction = "RIGHT"

@onready var act_time = get_node("ActualizationTimer")
@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if act_time:
		act_time.start(0.2) # inicio el timer


func _input(event):
	# print(current_direction)

	if event.is_action_pressed("right"):
		current_direction = "RIGHT"
	if event.is_action_pressed("left"):
		current_direction = "LEFT"
	if event.is_action_pressed("up"):
		current_direction = "UP"
	if event.is_action_pressed("down"):
		current_direction = "DOWN"


func _on_actualization_timer_timeout():
	var snake_head = Vector2(snake[0][0], snake[0][1]) # vector2 a la cabeza de la snake
	snake_head += directions[current_direction] * snake_speed # asigno nueva posicion
	snake_head.x = clamp(snake_head.x, 0, Global.GRID_SIZE_X - 1)
	snake_head.y = clamp(snake_head.y, 0, Global.GRID_SIZE_Y - 1)
	
	snake[0] = [snake_head.x, snake_head.y] # actualizo la x y de la cabeza en el array
	
	sprite.position = snake_head*Global.scale
	print(snake[0])
