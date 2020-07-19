extends Node


""" 
Master dictionary of keywords and associated categories
If this became a long-term project, probably makes sense to not fully hardcode
and to use something like word2vec to get better context

Words here should be all lowercase, with category values all uppercase

Should consider adding some key phrases as easter eggs, e.g. 'open the pod bay doors'
TODO: explore adding external tools like Dialogflow for more chatbot-type functionality

TODO: re-add and work on 'what' responses
"""
var dir = {
	"kiss": "AFFECTION",
	"hug": "AFFECTION",
	"snog": "AFFECTION",
	"love": "AFFECTION",
	"happy": "AFFECTION",
	"cheer": "AFFECTION",
	"cheerful": "AFFECTION",
	"hope": "AFFECTION",
	"care": "AFFECTION",
	"nice": "AFFECTION",
	
	"yes": "AFFIRMATIVE",
	"okay" : "AFFIRMATIVE",
	"k": "AFFIRMATIVE",
	"ok": "AFFIRMATIVE",
	"sure": "AFFIRMATIVE",
	
	"attack": "AGGRESSION",
	"punch": "AGGRESSION",
	"hit": "AGGRESSION",
	"kill": "AGGRESSION",
	"fight": "AGGRESSION",
	"hate": "AGGRESSION",
	"annoy": "AGGRESSION",
	"annoying": "AGGRESSION",
	"pushy": "AGRESSION",
	"bossy": "AGRESSION",
	"bad": "AGRESSION",
	"hurt": "AGRESSION",
	
	"pet": "DEERP",
	"creature": "DEERP",
	"animal": "DEERP",
	"beast": "DEERP",
	"dog": "DEERP",
	"fox": "DEERP",
	"ghost": "DEERP",
	"deerp": "DEERP",
	"feed": "DEERP",
	"give": "DEERP",
	
	"say": "COMMAND",
	"out loud": "COMMAND",
	
	"north": "DIRECTION",
	"south": "DIRECTION",
	"west": "DIRECTION",
	"east": "DIRECTION",
	"left": "DIRECTION",
	"right": "DIRECTION",
	
	"outside": "EXPLORATION",
	"wander": "EXPLORATION",
	"walk": "EXPLORATION",
	"run": "EXPLORATION",
	"travel": "EXPLORATION",
	"explore": "EXPLORATION",
	
	"food": "EAT",
	"dinner": "EAT",
	"lunch": "EAT",
	"breakfast":"EAT",
	"eat": "EAT",
	"snack": "EAT",
	
	"harvest": "FARM",
	"till": "FARM",
	"fertilize": "FARM",
	"reap": "FARM",
	"farm": "FARM",
	"farming": "FARM",
	"sow": "FARM",
	"crops": "FARM",
	"crop": "FARM",
	"potato": "FARM",
	"potatoes": "FARM",
	"greenhouse": "FARM",
	
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
	
	"help": "HELP",
	
	"bathroom": "POTTY",
	"toilet": "POTTY", 
	"potty": "POTTY",
	"restroom": "POTTY",
	"pee": "POTTY",
	
	"relax": "ENTERTAINMENT",
	"break": "ENTERTAINMENT",
	"tv": "ENTERTAINMENT",
	"entertainment": "ENTERTAINMENT",
	"fun": "ENTERTAINMENT",
	
	"need": "MAINTENANCE",
	"needs": "MAINTENANCE",
	"check": "MAINTENANCE",
	
	"no": "NEGATIVE",
	"nope": "NEGATIVE",
	"negative": "NEGATIVE",
	"negatory": "NEGATIVE",
	"not": "NEGATIVE",
	
	"sleep": "SLEEP",

	"read" : "NOTE",
	"note" : "NOTE",
	"notes" : "NOTE",
	"page" : "NOTE",
	"pages" : "NOTE",
	"paper" : "NOTE",
	"papers" : "NOTE",
	"book": "NOTE",
	"logbook": "NOTE",
	
	"sudo": "SUDO",
	"debug": "SUDO",
	
	"why": "WHY",
	"how": "HOW",
	"who": "WHO",
	"when": "WHEN",
	"where": "WHERE",
	"what": "WHAT",
	
	"want": "WANT",
	
	"x ae a-12": "X",
	"x": "X",
	
	"talk": "TALK",
	"speak": "TALK"
	}
