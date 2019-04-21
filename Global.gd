extends Node

export var STARTING_SCOUTS := 3

var remainingCp := 0
var technology = {}
var lastTurnOrderBid := 0
onready var currentMaintance := STARTING_SCOUTS

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
