extends StaticBody2D

var col_scene = preload("res://scenes/colectable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func _on_area_2d_area_entered(area):
	if area.get_parent().is_in_group("player"):
		queue_free()
		call_deferred("create_fruit")



func create_fruit():
	var new_collectable = col_scene.instantiate()
	var col_poss = Vector2()
	
	var grid_size_x = Global.GRID_SIZE_X
	var grid_size_y = Global.GRID_SIZE_Y
	
	col_poss = Vector2(randi() % grid_size_x * Global.scale, randi() % grid_size_y * Global.scale)
	
	new_collectable.position = col_poss
	get_parent().call_deferred("add_child", new_collectable)
	
	print("[FRUIT CREATED AT: ", new_collectable.position / Global.scale, "]")
	
	var area2d = new_collectable.get_node("Area2D")
	
	if area2d:
		var collision_area = area2d.get_node("CollisionShape2D")
		if collision_area:
			print("[FRUIT COLLISION AT: ", collision_area.global_position / Global.scale , "]")
		else:
			print("[NO COLLISION AREA FOUND]")
	else:
		print("[NO AREA2D FOUND]")
	
	var sprite = new_collectable.get_node("Sprite2D")
	
	if sprite:
		print("[FRUIT SPRITE AT: ", sprite.global_position / Global.scale, "]")
	else:
		print("[NO SPRITE FOUND]")
