extends Node

# From input
signal new_keywords
signal meaningless_input
signal stat_check
signal queue_check
signal player_speech
signal game_started

# From player
signal new_thought
signal new_action
signal new_destination
signal animate
signal start_exploring
signal nearest_note_requested
signal potato_count
signal last_note_found

# From character
signal reached_destination
signal start_airlock
signal animation_done
signal tended_plants
signal path_requested
signal new_patrol_path
signal watching_started
signal watching_finished
signal new_note
signal speech_finished
signal inside
signal outside

# From plants
signal harvested  # TODO: rethink how signals should look with more than one plant type
signal watered 
signal sowed

# From building
signal outside_lock_triggered
signal inside_lock_triggered
signal airlock_finished
signal entered_living_room
signal exited_living_room
signal greenhouse_exited
signal greenhouse_entered

# From mystery notes
signal note_detected

# From aliens
signal quest
signal alien_arrived
signal game_over

# From animals
signal fed_animal
signal scared_animal
