extends TitleAmount

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("existingShips_changed", self, "_update")
	call_deferred("_update")

func _update():
	set_value(Global.getExistingMaintance())