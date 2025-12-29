extends CharacterBody3D
class_name YellowFerret

@export var mask_health : int = 3
@export var WALK_SPEED : float = 1

@onready var skeleton : Skeleton3D = $ferret_YellowMask/Armature/Skeleton3D
@onready var head_bone_id : int = skeleton.find_bone("Head")
@onready var mask_bone_start_id : int = skeleton.find_bone("Head.001")
@onready var mask_bone_end_id : int = skeleton.find_bone("Head.001_end")

@onready var anim : AnimationPlayer = $ferret_YellowMask/AnimationPlayer
@onready var mask_hurtbox: RigidBody3D = %"Mask Hurtbox"
@onready var head_hurtbox: StaticBody3D = %"Head Hurtbox"
@onready var mask_mesh: MeshInstance3D = $ferret_YellowMask/Armature/Skeleton3D/Mask
@onready var navigation_agent: NavigationAgent3D = %NavigationAgent3D


var mask_fallen : bool = false


func _ready() -> void:
	anim.play("Armature|Walk")
	head_hurtbox.process_mode = Node.PROCESS_MODE_DISABLED

func _process(_delta: float) -> void:
	if not mask_fallen:
		var mask_start_pos : Vector3 = skeleton.get_bone_global_pose(mask_bone_start_id).origin
		var mask_end_pos : Vector3 = skeleton.get_bone_global_pose(mask_bone_end_id).origin
		mask_hurtbox.global_position = skeleton.to_global((mask_start_pos + mask_end_pos)/2)
	head_hurtbox.global_position = skeleton.to_global(skeleton.get_bone_global_pose(head_bone_id).origin)
	
	if self.get_real_velocity():
		anim.play("Armature|Walk")
	else:
		anim.play("Idle")

func _physics_process(delta: float) -> void:
	var destination := navigation_agent.get_next_path_position()
	var local_destination := destination - self.global_position
	var direction = local_destination.normalized()
	
	self.velocity = direction * WALK_SPEED
	move_and_slide()

func take_damage() -> void:
	if mask_fallen:
		# ferret dies
		var tween = get_tree().create_tween()
		tween.tween_property($ferret_YellowMask/Armature/Skeleton3D/Character, "transparency", 1.0, 1.0)
		tween.tween_callback(self.queue_free)
		
	
	mask_health -= 1
	if mask_health <= 0:
		head_hurtbox.process_mode = Node.PROCESS_MODE_INHERIT
		
		# clone the mask for later
		var mesh_copy : MeshInstance3D = mask_mesh.duplicate()
		mask_hurtbox.add_child(mesh_copy)
		
		# clean up original
		mask_mesh.visible = false
		
		# tuning
		mesh_copy.scale *= 8
		mesh_copy.position.y += .01
		mask_hurtbox.mass = 8
		mask_hurtbox.get_child(0).scale *= .6
		mask_hurtbox.global_position = head_hurtbox.global_position
		
		# drop the mask copy
		mask_hurtbox.reparent(get_tree().current_scene)
		mask_hurtbox.freeze = false
		
		mask_fallen = true


func _on_celebrate_zone_body_entered(body: Node3D) -> void:
	if body is CakeMaster:
		navigation_agent.set_target_position(body.global_position)
