class_name Detectors
extends Node2D

# new/was refering to incoming tiles,
# old/now refering to tiles going out of screen

var ground_was_colliding: bool = false
var ground_now_colliding: bool = false
var pipe_now_colliding: bool = false

@onready var ceiling: Area2D = $Ceiling
@onready var new_ground: RayCast2D = $NewGround
@onready var old_ground: RayCast2D = $OldGround
@onready var old_pipe: RayCast2D = $OldPipe


func _ready():
	ceiling.area_entered.connect(_on_Ceiling_area_entered)


func _physics_process(_delta: float):
	ground_was_colliding = _was_colliding(
		new_ground, ground_was_colliding, "ground_stopped_colliding"
	)
	ground_now_colliding = _now_colliding(
		old_ground, ground_now_colliding, "ground_started_colliding"
	)
	pipe_now_colliding = _now_colliding(old_pipe, pipe_now_colliding, "pipe_started_colliding")


func _was_colliding(detector: RayCast2D, flag: bool, signal_name: String):
	if detector.is_colliding():
		return true
	if flag:
		Event.emit_signal(signal_name)
		return false
	return true


func _now_colliding(detector: RayCast2D, flag: bool, signal_name: String):
	if detector.is_colliding():
		if not flag:
			Event.emit_signal(signal_name)
			return true
	return false


func _on_Ceiling_area_entered(_area: Area2D):
	Event.player_collide.emit()
	ceiling.set_collision_mask_value(1, false)
