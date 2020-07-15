extends Node

# Just did three for now; feel free to change/add categories and keywords
enum Category {
	AFFECTION, 
	AGGRESSION, 
	EXPLORATION, 
	FOOD, 
	GREETING,
	MAINTENANCE,
	RESOURCES,
	SOCIAL,
	SUDO,
	WHY
	}

""" 
Master dictionary of keywords and associated categories
If this became a long-term project, probably makes sense to not fully hardcode
and to use something like word2vec to get better context

Words here should be all lowercase

Should consider adding some key phrases as easter eggs, e.g. 'open the pod bay doors'
"""
var dir = {
	"kiss": Category.AFFECTION,
	"hug": Category.AFFECTION,
	"snog": Category.AFFECTION,
	"love": Category.AFFECTION,
	
	"attack": Category.AGGRESSION,
	"punch": Category.AGGRESSION,
	"hit": Category.AGGRESSION,
	"kill": Category.AGGRESSION,
	"fight": Category.AGGRESSION,
	"hate": Category.AGGRESSION,
	"annoy": Category.AGGRESSION,
	"annoying": Category.AGGRESSION,
	
	"outside": Category.EXPLORATION,
	"left": Category.EXPLORATION,
	"right": Category.EXPLORATION,
	"up": Category.EXPLORATION,
	
	"food": Category.FOOD,
	"farm": Category.FOOD,
	"eat": Category.FOOD,
	"harvest": Category.FOOD,
	"till": Category.FOOD,
	"fertilize": Category.FOOD,
	"reap": Category.FOOD,
	"sow": Category.FOOD,
	"crops": Category.FOOD,
	"crop": Category.FOOD,
	"potato": Category.FOOD,
	"potatoes": Category.FOOD,
	"dinner": Category.FOOD,
	"lunch": Category.FOOD,
	"breakfast": Category.FOOD,
	
	"hi": Category.GREETING,
	"hello": Category.GREETING,
	"hey": Category.GREETING,
	"howdy": Category.GREETING,
	"g'day": Category.GREETING,
	"aloha": Category.GREETING,
	"greetings": Category.GREETING,
	
	"bathroom": Category.MAINTENANCE,
	"toilet": Category.MAINTENANCE,
	"potty": Category.MAINTENANCE,
	"tv": Category.MAINTENANCE,
	"restroom": Category.MAINTENANCE,
	"relax": Category.MAINTENANCE,
	"break": Category.MAINTENANCE,
	"need": Category.MAINTENANCE,
	"needs": Category.MAINTENANCE,
	"check": Category.MAINTENANCE,
	
	"sudo": Category.SUDO,
	"debug": Category.SUDO,
	
	"why": Category.WHY
	}
