extends Node

signal game_start
signal game_over
signal new_score(score: int, high_score: int)

signal player_jump
signal player_score
signal player_collide
signal player_death

signal ground_stopped_colliding
signal ground_started_colliding
signal pipe_started_colliding

signal set_volume(linear_volume: float)
signal hit_sound_finished