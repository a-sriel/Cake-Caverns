extends Overworld

func _ready() -> void:
	$CinematicCamera.make_current()
	$Player.hide()
	$AnimModels/ProtagFerret_Idle.show()
	$AnimModels/ProtagFerret_Walk.hide()
	$AnimModels/ProtagFerret_Surprise.hide()
	$AnimModels/BanditFerret_Walk.hide()
	$AnimModels/BanditFerret_Stealing.hide()
	
	$"Cake Trail".show()
	
	var anim1 : Animation = $AnimModels/ProtagFerret_Idle/ferret/AnimationPlayer.get_animation("Celebrate")
	anim1.loop_mode = (Animation.LOOP_LINEAR)
	$AnimModels/ProtagFerret_Idle/ferret/AnimationPlayer.play("Celebrate")
	$AnimationPlayer.play("EndCutscene")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$fade_transition.show()
	$fade_transition/fade_timer.start()
	$fade_transition/AnimationPlayer.play("fade_out") 
	
func _on_fade_timer_timeout() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://credits.tscn")
