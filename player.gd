extends RigidBody

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


## Character inventory
# We as the player don't see this or interact with it directly, so it doesn't need to be too flash

### Queue
# Each time a new item is added, as well as at random, semi-frequent intervals, the character will assess the
# value and priority of each entry, and sort accordingly. Additional weight is made towards an act that the player
# has insisted on, but bad circumstances (such as weather, health) can still deter the character enough
# to avoid doing it.

var queue = []

func _ready():
	addToQueue("Test")


func addToQueue(task):
	if task == null:
		return
	else:
		queue.append(task)
