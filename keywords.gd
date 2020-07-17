extends Node


""" 
Master dictionary of keywords and associated categories
If this became a long-term project, probably makes sense to not fully hardcode
and to use something like word2vec to get better context

Words here should be all lowercase, with category values all uppercase

Should consider adding some key phrases as easter eggs, e.g. 'open the pod bay doors'
TODO: explore adding external tools like Dialogflow for more chatbot-type functionality
"""
var dir = {
	"kiss": "AFFECTION",
	"hug": "AFFECTION",
	"snog": "AFFECTION",
	"love": "AFFECTION",
	
	"attack": "AGGRESSION",
	"punch": "AGGRESSION",
	"hit": "AGGRESSION",
	"kill": "AGGRESSION",
	"fight": "AGGRESSION",
	"hate": "AGGRESSION",
	"annoy": "AGGRESSION",
	"annoying": "AGGRESSION",
	
	"pet": "ANIMAL",
	"creature": "ANIMAL",
	"animal": "ANIMAL",
	"beast": "ANIMAL",
	"dog": "ANIMAL",
	"fox": "ANIMAL",
	"ghost": "ANIMAL",
	
	"say": "COMMAND",
	
	"north": "DIRECTION",
	"south": "DIRECTION",
	"west": "DIRECTION",
	"east": "DIRECTION",
	
	"outside": "EXPLORATION",
	"wander": "EXPLORATION",
	"walk": "EXPLORATION",
	"run": "EXPLORATION",
	"travel": "EXPLORATION",
	"explore": "EXPLORATION",
	"find": "EXPLORATION",
	
	"food": "FOOD",
	"farm": "FOOD",
	"eat": "FOOD",
	"harvest": "FOOD",
	"till": "FOOD",
	"fertilize": "FOOD",
	"reap": "FOOD",
	"sow": "FOOD",
	"crops": "FOOD",
	"crop": "FOOD",
	"potato": "FOOD",
	"potatoes": "FOOD",
	"dinner": "FOOD",
	"lunch": "FOOD",
	"breakfast":"FOOD",
	
	"hi": "GREETING",
	"hello": "GREETING",
	"hey": "GREETING",
	"howdy": "GREETING",
	"g'day": "GREETING",
	"aloha": "GREETING",
	"greetings": "GREETING",
	
	"bye": "GOODBYE",
	"goodbye": "GOODBYE",
	"bai": "GOODBYE",
	
	"bathroom": "MAINTENANCE",
	"toilet": "MAINTENANCE",
	"potty": "MAINTENANCE",
	"tv": "MAINTENANCE",
	"restroom": "MAINTENANCE",
	"relax": "MAINTENANCE",
	"break": "MAINTENANCE",
	"need": "MAINTENANCE",
	"needs": "MAINTENANCE",
	"check": "MAINTENANCE",
	"sleep": "MAINTENANCE",
	"pee": "MAINTENANCE",
	
	"read" : "READ",
	"note" : "READ",
	"notes" : "READ",
	"page" : "READ",
	"pages" : "READ",
	
	"sudo": "SUDO",
	"debug": "SUDO",
	
	"why": "WHY",
	"how": "HOW",
	"who": "WHO",
	"what": "WHAT",
	"when": "WHEN",
	"where": "WHERE"
	}
