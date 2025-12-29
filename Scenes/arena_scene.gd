extends Node3D

@export var ferret_red : PackedScene
@export var ferret_blue : PackedScene
@export var ferret_yellow : PackedScene
@onready var cake: Cake = $Cake
@onready var bandito: Bandito = $Bandito


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().paused = true
		$Pause_Menu.show()
	
func _on_resume_pressed() -> void:
	$Pause_Menu.hide()
	get_tree().paused = false
	$Player.capture_mouse()
	
func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
	
func _on_close_pressed() -> void:
	get_tree().quit()


func _on_bandito_boss_took_damage() -> void:
	var rand_i : int = randi_range(1, 3)
	var rand_ferret : Node
	
	match rand_i:
		1:
			rand_ferret = ferret_red.instantiate()
		2:
			rand_ferret = ferret_blue.instantiate()
		3:
			rand_ferret = ferret_yellow.instantiate()
	
	rand_ferret.global_position = $"Enemy Spawn".global_position
	rand_ferret.get_child(4).get_child(0).shape.radius *= 3
	self.add_child(rand_ferret)
	

func _on_bandito_spawn_the_cake(pos:Vector3) -> void:
	cake.global_position = pos
