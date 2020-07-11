extends Node

# Just did three for now; feel free to change/add categories and keywords
enum Category {AGGRESSION, AFFECTION, EXPLORATION}

""" 
Master dictionary of keywords and associated categories
If this became a long-term project, probably makes sense to not fully hardcode
and to use something like word2vec to get better context

Currently these are case-sensitive, meaning 'attack' would highlight and
be parsed correctly, but 'Attack' would not be.
"""
var dir = {
	"attack": Category.AGGRESSION,
	"punch": Category.AGGRESSION,
	"hit": Category.AGGRESSION,
	"kill": Category.AGGRESSION,
	"fight": Category.AGGRESSION,
	
	"kiss": Category.AFFECTION,
	"hug": Category.AFFECTION,
	"snog": Category.AFFECTION,
	"love": Category.AFFECTION,
	
	"outside": Category.EXPLORATION,
	"left": Category.EXPLORATION,
	"right": Category.EXPLORATION,
	"up": Category.EXPLORATION,
	}
