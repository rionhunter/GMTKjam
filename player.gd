extends Node

# The player and the character are documented as two different entities

### Play states
# default: the player can enter generic stuff into the text field
# determine: the player must make a choice (through text) and can't change subject
# dialogue: The player's text is being ported directly through the mouth of the character

enum playerState {default, determine, dialogue}
var state = playerState.default 

### Character Stats
var character = {"FIRST_NAME": "", "LAST_NAME": "", "NICKNAMES": [],}
# Stretch Goal: Mood

# The main stats built from others
var mood : float
var body : float
var mind : float
var stat_max := 10.0

# Lower level stats (higher == better) 
# (all stats have same stat_max but could change faster or slower or have more
# weighting in the main stats above)
var hunger := 4.0
var health := 10.0
var happiness := 7.0
var disposition := 8.0
var bladder := 10.0
var rested := 10.0
var weather : float # Should have weather condition be controled elsewhere and send signals

#TODO:

var hydration := 10.0


## Character inventory
# We as the player don't see this or interact with it directly, so it doesn't need to be too flash
var inventory = {"food": {"potatoes" : 1, "carrots" : 0}}
var potatoes := 1
var notes := []
var first_note := true
var note_index := 0

### Queue
# Each time a new item is added, as well as at random, semi-frequent intervals, the character will assess the
# value and priority of each entry, and sort accordingly. Additional weight is made towards an act that the player
# has insisted on, but bad circumstances (such as weather, health) can still deter the character enough
# to avoid doing it.

var queue := []
var predisposed := false
var current_action := "none"

### Responses
# Keeping track of flavor text to print to screen when 
# new thoughts are suggested by the player 

var bark_dict := {}
var rng = RandomNumberGenerator.new()
var failed_attempts := 0
const max_attempts_before_response := 3
const buffer_time := 1.0

### Destinations
# Spatial nodes that show where the player should go to complete an action

var destinations := {}


func _ready():
	rng.randomize()
	#addToQueue("Test action")
	
	# Connect to input signals
	EventHub.connect("new_keywords", self, "_on_new_keywords")
	EventHub.connect("meaningless_input", self, "_on_meaningless_input")
	EventHub.connect("stat_check", self, "list_stats")
	EventHub.connect("queue_check", self, "list_queue")
	EventHub.connect("reached_destination", self, "on_destination_reached")
	EventHub.connect("animation_done", self, "on_action_done")
	EventHub.connect("harvested", self, "on_harvest")
	EventHub.connect("note_detected", self, "_on_note_detected")
	EventHub.connect("game_started", self, "_on_game_started")
	
	# Open and parse response lines
	var file = File.new()
	file.open("res://barks.json", file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	bark_dict = result_json.result
	file.close()


func set_destinations(dests_in : Dictionary):
	destinations = dests_in


func list_stats():
	# For debugging purposes, triggered when entering "stats" in the input line
	# Only showing stats that decrement automatically for right now
	print("hunger: ", hunger)
	print("bladder: ", bladder)
	print("rested: ", rested)
	print("happiness: ", happiness)


func list_queue():
	# For debugging purposes, triggered when entering "queue" in the input line
	print("queue: ", queue)


func on_harvest(num : int):
	var message = str(num) + " more potatoes to stuff in my pockets"
	EventHub.emit_signal("new_thought", message)
	potatoes += num
	message = "Now I've got " + str(potatoes) + " total"
	EventHub.emit_signal("new_thought", message)


func addToQueue(task):
	if task == null or queue.has(task) or current_action == task:
		return
	else:
		queue.append(task)	
		yield(get_tree().create_timer(buffer_time), "timeout")
		think_about("yes", task)
		

func manage_queue():
	# Prioritize queue by what if analysis: what task makes the most sense?
	# easiest would just be to do next thing in queue
	if predisposed:
		return
	next_action()


func choose_action():
	# Chooses the next action(s) to add to queue
	# Called when not doing anything and nothing in queue,
	# or when some vitals drop below a threshold

	random_response("CHOOSE_ACTION")
	yield(get_tree().create_timer(buffer_time), "timeout")
	
	var threshold := 5.0
	if bladder <= threshold:
		addToQueue("potty")
	if hunger <= threshold:
		addToQueue("eat")
	if rested <= threshold:
		addToQueue("sleep")
	if happiness <= threshold or len(queue) == 0:
		addToQueue("entertainment")


func next_action():
	# Pulls the next action from the prioritized queue
	if len(queue) == 0: # nothing in the queue
		choose_action()
		return
	if predisposed: # already doing something
		return

	predisposed = true
	current_action = queue.pop_front()
	think_about("start")
	
	if current_action == "explore":
		EventHub.emit_signal("start_exploring")
		return
	
	if !destinations.has(current_action):
		print("ERROR: this action not coded")
		EventHub.emit_signal("new_action", "going to do: " + current_action)
		EventHub.emit_signal("new_destination", destinations["eat"])

	else:
		EventHub.emit_signal("new_destination", destinations[current_action])


func think_about(action : String, subject := current_action):
	var resultingThought = (subject + "_" + action)
	resultingThought = resultingThought.to_upper()
	random_response(resultingThought)


func next(action : String):
	EventHub.emit_signal("new_action", action)
	EventHub.emit_signal("new_destination")


func random_response(category : String):
	if !bark_dict.has(category):
		print("no phrases found for: ", category)
		return
	var responses = bark_dict[category]
	var i = rng.randi_range(0, len(responses)-1)
	EventHub.emit_signal("new_thought", responses[i])


func check_food():
	"""
	Food thought has been suggested by player: check state of hunger, 
	pantry, and crops, and see if should add something to our queue
	
	TODO: implement checking logic, using signals with farm and pantry 
	if needed
	"""
	if potatoes < 5:
		addToQueue("farm")
	else:
		think_about("no", "farm")
		yield(get_tree().create_timer(buffer_time), "timeout")
		
	if hunger < 7:
		addToQueue("eat")
	else:
		think_about("no", "eat")


func check_stats():
	"""
	Maintenance thought has been suggested by player: check state of bladder,
	sleep, and entertainment, and see if should add something to our queue.
	
	All stats are out of 10, with 10 being the best condition
	"""
	var cutoff := 5.0
	if min(hunger, min(rested, min(happiness, bladder))) <= cutoff:
		choose_action()


func on_destination_reached():
	think_about("arrive")
	if current_action == "eat" and potatoes <= 0:
		think_about("error")
		addToQueue("farm")
		predisposed = false
		return
	EventHub.emit_signal("animate", current_action)


func on_action_done():
	# Method to call at end of animation to replace hard coded wait times in below functions
	think_about("finish")
	match current_action:
		"farm":
			EventHub.emit_signal("tended_plants")
		"entertainment":
			happiness = min(happiness + 5, stat_max)
			yield(get_tree().create_timer(buffer_time*2), "timeout")
		"eat":
			hunger = max(hunger + 5, stat_max)
			potatoes -= 1
			var potato_string = "Now I have " + str(potatoes) + " left."
			EventHub.emit_signal("new_thought", "That's one potato down. " + potato_string)
		"potty":
			bladder = stat_max
		"sleep":
			rested = stat_max
	current_action = "none"
	predisposed = false


func update_priorities():
	# These stats aren't currently used for anything
	mood = body + mind + weather
	body = hunger * bladder * health
	mind = disposition * rested * happiness
	manage_queue()


func read_note():
	if len(notes) > 0:
		random_response("NOTE_YES")
		yield(get_tree().create_timer(buffer_time*1.5), "timeout")
		EventHub.emit_signal("new_note", notes.pop_front())
	else:
		random_response("NOTE_ERROR")


func _on_new_keywords(input: Dictionary) -> void:
	failed_attempts = 0

	for word in input:
		if Keywords.dir[word] == "SUDO":
			queue.clear()
			return
		random_response(Keywords.dir[word])
		match Keywords.dir[word]:
			"EXPLORATION":
				addToQueue("explore")
			"FOOD":
				check_food()
			"MAINTENANCE":
				choose_action()
			"READ":
				read_note()


func _on_meaningless_input():
	"""
	Function will emit a random helper text response after several inputs 
	without any keywords, else will emit a random 'misc phrase'
	This is to avoid it seeming like an empty void and give the player 
	direction towards what works.
	"""
	failed_attempts += 1
	if failed_attempts >= max_attempts_before_response:
		random_response("HELPER_TEXT")
	else:
		random_response("MISC")


func _on_StatusTimer_timeout():
	"""
	When the timer node times out (autostarts on load), decrement applicable stats 
	and reassess priorities. If any stats get too low, add the corresponding action
	to the queue.
	"""
	var decrement = .05 # Arbitrary for now
	
	hunger = max(hunger - decrement*4, 0)
	if hunger == 0 and !queue.has("eat"):
		random_response("HUNGER")
		addToQueue("eat")
		
	bladder = max(bladder - decrement*5, 0)
	if bladder == 0 and !queue.has("potty"):
		random_response("BLADDER")
		addToQueue("potty")
		
	rested = max(rested - decrement*3, 0)
	if rested == 0 and !queue.has("sleep"):
		random_response("ENERGY")
		addToQueue("sleep")
		
	happiness = max(happiness - decrement, 0)
	if happiness == 0 and !queue.has("entertainment"):
		random_response("DEPRESSION")
		addToQueue("entertainment")
		
	update_priorities()


func _on_note_detected():
# Saves note text to player's notes array in order shown in barks.json file 
	var all_notes = bark_dict["NOTES"]
	if first_note:
		EventHub.emit_signal("new_thought", "Huh. Picked up a torn page with some writing on it")
		first_note = false
	else:
		random_response("ANOTHER_NOTE")
	if note_index >= len(all_notes): # More notes in world than available dialogue
		EventHub.emit_signal("new_thought", "This one is blank")
	else:
		notes.append(all_notes[note_index])
		print("appended: ", all_notes[note_index])
		note_index += 1


func _on_RandThoughtTimer_timeout():
	random_response("BACKGROUND")


func _on_game_started():
	update_priorities()
	$StatusTimer.start()
