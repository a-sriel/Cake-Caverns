extends RigidBody3D

@export var amount : int = 25
@export var in_boss_arena : bool = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CakeMaster:
		body.refill_pies(amount)
		amount *= .5
		self.scale *= .8
		
		if amount <= 0:
			if not in_boss_arena:
				self.queue_free()
			
			disable_self()

func disable_self() -> void:
	self.visible = false
	call_deferred("set_process", PROCESS_MODE_DISABLED)
	$"Respawn Timer".start()

func enable_self() -> void:
	amount = 25
	self.scale = Vector3.ONE
	self.visible = true
	call_deferred("set_process", PROCESS_MODE_INHERIT)

func _on_respawn_timer_timeout() -> void:
	enable_self()
