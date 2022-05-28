class_name WorldDetector
extends Node2D

signal ground_stopped_colliding
signal ground_started_colliding
signal pipe_started_colliding

# new/was refering to incoming tiles,
#	old/now referign to tiles going out of screen
onready var new_ground: RayCast2D = $NewTile
onready var old_ground: RayCast2D = $OldTile
onready var old_pipe: RayCast2D = $OldPipe
var ground_was_colliding: bool = false
var ground_now_colliding: bool = false
var pipe_now_colliding: bool = false


func _physics_process(delta: float) -> void:
	ground_was_colliding = _was_colliding(new_ground, ground_was_colliding, "ground_stopped_colliding")
	ground_now_colliding = _now_colliding(old_ground, ground_now_colliding, "ground_started_colliding")
	pipe_now_colliding = _now_colliding(old_pipe, pipe_now_colliding, "pipe_started_colliding")


func _was_colliding(detector: RayCast2D, flag: bool, signal_name: String) -> bool:
	if detector.is_colliding():
		return true
	if flag:
		emit_signal(signal_name)
		return false
	return true


func _now_colliding(detector: RayCast2D, flag: bool, signal_name: String) -> bool:
	if detector.is_colliding():
		if not flag:
			emit_signal(signal_name)
			return true
	return false
