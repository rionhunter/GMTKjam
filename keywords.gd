extends Node

# Just did three for now; feel free to change/add categories and keywords
enum Category {
	AFFECTION, 
	AGGRESSION, 
	ANIMAL,
	COMMAND,
	DIRECTION,
	EXPLORATION, 
	FOOD, 
	GREETING,
	MAINTENANCE,
	READ,
	RESOURCES,
	SOCIAL,
	SUDO,
	WHY,
	HOW,
	WHO,
	WHAT,
	WHERE,
	WHEN
	}

""" 
Master dictionary of keywords and associated categories
If this became a long-term project, probably makes sense to not fully hardcode
and to use something like word2vec to get better context

Words here should be all lowercase

Should consider adding some key phrases as easter eggs, e.g. 'open the pod bay doors'
TODO: explore adding external tools like Dialogflow for more chatbot-type functionality
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
	
	"pet": Category.ANIMAL,
	"creature": Category.ANIMAL,
	"animal": Category.ANIMAL,
	"beast": Category.ANIMAL,
	"dog": Category.ANIMAL,
	"fox": Category.ANIMAL,
	"ghost": Category.ANIMAL,
	
	"say": Category.COMMAND,
	
	"north": Category.DIRECTION,
	"south": Category.DIRECTION,
	"west": Category.DIRECTION,
	"east": Category.DIRECTION,
	
	"outside": Category.EXPLORATION,
	"wander": Category.EXPLORATION,
	"walk": Category.EXPLORATION,
	"run": Category.EXPLORATION,
	"travel": Category.EXPLORATION,
	"explore": Category.EXPLORATION,
	"find": Category.EXPLORATION,
	
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
	"sleep": Category.MAINTENANCE,
	"pee": Category.MAINTENANCE,
	
	"read" : Category.READ,
	"note" : Category.READ,
	"notes" : Category.READ,
	"page" : Category.READ,
	"pages" : Category.READ,
	
	"sudo": Category.SUDO,
	"debug": Category.SUDO,
	
	"why": Category.WHY,
	"how": Category.HOW,
	"who": Category.WHO,
	"what": Category.WHAT,
	"when": Category.WHEN,
	"where": Category.WHERE
	}
