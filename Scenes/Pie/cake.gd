extends Node3D
class_name Cake



func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CakeMaster:
		# End the game here
		print("You win!!")
