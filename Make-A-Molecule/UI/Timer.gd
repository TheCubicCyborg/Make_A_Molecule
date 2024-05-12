extends Control

@onready var label = $Label
const startTime = 300 
@onready var time:float = startTime

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if time > 0:
		time -= delta 
	if time < 0:
		time = 0
	updateLabel()

	
	
func formatTime(time:float):
	var minutes = int(time)/60
	var seconds = int(time)%60
	if seconds < 10 : 
		return str(minutes) + " : 0" + str(seconds)
	return str(minutes) + " : " + str(seconds)
	
func updateLabel():
	label.text = "Time: " + formatTime(time)
