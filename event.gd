extends Node

signal game_start
signal game_over
signal game_pause(pause: bool)
signal game_restart
signal new_score(score: int, high_score: int)

signal player_jump
signal player_score
signal player_collide
signal player_death

signal ground_stopped_colliding
signal ground_started_colliding
signal pipe_started_colliding

signal set_mute(mute: bool)
signal set_volume(linear_volume: float)
signal hit_sound_finished

signal bird_new_sprite(index: int)
signal bird_prev_sprite
signal bird_next_sprite
signal bg_new_sprite(index: int)
signal bg_prev_sprite
signal bg_next_sprite
