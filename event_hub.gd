extends Node

# From input
signal new_keywords
signal meaningless_input
signal stat_check
signal queue_check

# From player
signal new_thought
signal new_action
signal new_destination
signal in_house
signal outside
signal animate

# From character
signal reached_destination
signal start_airlock
signal animation_done
signal tended_plants
signal path_requested

# From plants
signal harvested  # TODO: rethink how signals should look with more than one plant type
signal watered 
signal sowed

# From building
signal outside_lock_triggered
signal inside_lock_triggered
signal airlock_finished
