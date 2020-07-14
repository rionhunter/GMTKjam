extends Node

# The player and the character are documented as two different entities

### Play states
# default: the player can enter generic stuff into the text field
# determine: the player must make a choice (through text) and can't change subject
# dialogue: The player's text is being ported directly through the mouth of the character

enum playerState {default, determine, dialogue}
var state = playerState.default 

### Character Stats
# Control over the character can be lost when stats don't align, etc
# Basic bodily needs, health
# Wallet
# 
# Stretch Goal: Mood

# The main stats built from others
var mood : float
var body : float
var mind : float
var stat_max := 10.0

# Lower level stats (higher == better) 
# (all stats have same stat_max but could change faster or slower or have more
# weighting in the main stats above)
var hunger := 10.0
var health := 10.0
var happiness := 7.0
var disposition := 8.0
var bladder := 10.0
var rested := 10.0
var weather : float # Should have weather condition be controled elsewhere and send signals

## Character inventory
# We as the player don't see this or interact with it directly, so it doesn't need to be too flash
var inventory = {"food": {"potatoes" : 1, "carrots" : 0}}
var potatoes := 1

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

var door_loc : Vector3
var window_loc : Vector3
var plant_loc : Vector3


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
	
	# Open and parse response lines
	var file = File.new()
	file.open("res://barks.json", file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	bark_dict = result_json.result
	file.close()
	update_priorities()

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
	
	match current_action:
		"farm":
			EventHub.emit_signal("new_destination", plant_loc)
		"eat":
			EventHub.emit_signal("new_destination", door_loc)
		"sleep":
			EventHub.emit_signal("new_destination", door_loc)
		"potty":
			EventHub.emit_signal("new_destination", door_loc)
		"entertainment":
			EventHub.emit_signal("new_destination", door_loc)
		_:
			EventHub.emit_signal("new_action", "going to do: " + current_action)
			EventHub.emit_signal("new_destination", door_loc)
			print("ERROR: this action not coded")


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
		return
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
	print("current action: ", current_action)
	#EventHub.emit_signal("new_thought", "arrived", current_action)
	think_about("arrive")
	match current_action:
		"farm":
			EventHub.emit_signal("animate", "work")
		"entertainment":
			yield(get_tree().create_timer(buffer_time), "timeout")
			EventHub.emit_signal("in_house")
			yield(get_tree().create_timer(buffer_time*10), "timeout")
			EventHub.emit_signal("outside")
			on_action_done()
		"potty":
			EventHub.emit_signal("in_house")
			bladder = stat_max
			yield(get_tree().create_timer(buffer_time*5), "timeout")
			EventHub.emit_signal("outside")
			on_action_done()
		"eat":
			EventHub.emit_signal("in_house")
			if potatoes <= 0:
				addToQueue("farm")
				predisposed = false
			else:
				hunger = max(hunger + 5, stat_max)
				yield(get_tree().create_timer(buffer_time*7), "timeout")
				potatoes -= 1
				var potato_string = "Now I have " + str(potatoes) + " left."
				EventHub.emit_signal("new_thought", "That's one potato down. " + potato_string)
				EventHub.emit_signal("outside")
				on_action_done()
		"sleep":
			EventHub.emit_signal("in_house")
			yield(get_tree().create_timer(buffer_time*10), "timeout")
			EventHub.emit_signal("outside")
			on_action_done()
		_:
			print("action not specified; I'll just sit in the house for a bit")
			EventHub.emit_signal("in_house")
			yield(get_tree().create_timer(buffer_time*5), "timeout")
			EventHub.emit_signal("outside")
			on_action_done()


func on_action_done():
	# Method to call at end of animation to replace hard coded wait times in below functions
	think_about("finish")
	match current_action:
		"farm":
			potatoes +=1
			var potato_string = "current potatoes: " + str(potatoes)
			EventHub.emit_signal("new_action", "received 1 potato. " + potato_string)
		"entertainment":
			EventHub.emit_signal("outside")
			happiness = min(happiness + 5, stat_max)
			yield(get_tree().create_timer(buffer_time*2), "timeout")
	current_action = "none"
	predisposed = false


func update_priorities():
	# These stats aren't currently used for anything
	mood = body + mind + weather
	body = hunger * bladder * health
	mind = disposition * rested * happiness
	manage_queue()


func _on_new_keywords(input: Dictionary) -> void:
	failed_attempts = 0
	for word in input:
		match Keywords.dir[word]:
			Keywords.Category.AGGRESSION:
				random_response("AGGRESSION")
			Keywords.Category.AFFECTION:
				random_response("AFFECTION")
			Keywords.Category.EXPLORATION:
				random_response("EXPLORATION")
			Keywords.Category.FOOD:
				random_response("FOOD")
				yield(get_tree().create_timer(buffer_time), "timeout")
				check_food()
			Keywords.Category.GREETING:
				random_response("GREETING")
			Keywords.Category.MAINTENANCE:
				random_response("MAINTENANCE")
				yield(get_tree().create_timer(buffer_time), "timeout")
				
			_: #input is a keyword in keywords.gd, but no response defined in match statement
				random_response("MISC")


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
	
	hunger = max(hunger - decrement*5, 0)
	if hunger == 0:
		random_response("HUNGER")
		addToQueue("eat")
		
	bladder = max(bladder - decrement*7, 0)
	if bladder == 0:
		random_response("BLADDER")
		addToQueue("potty")
		
	rested = max(rested - decrement*3, 0)
	if rested == 0:
		random_response("ENERGY")
		addToQueue("sleep")
		
	happiness = max(happiness - decrement, 0)
	if happiness == 0:
		random_response("DEPRESSION")
		addToQueue("entertainment")
		
	update_priorities()


func _on_RandThoughtTimer_timeout():
	random_response("BACKGROUND")
