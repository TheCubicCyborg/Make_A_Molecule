extends Control

@onready var label = $Label
@onready var score:int = scoreStart
const scoreStart = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	updateLabel()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func Addscore(points:int):
	score += points 
	updateLabel()
 

func updateLabel(): 
	label.text = "Score: " + str(score)
	
func _input(event):
	if event is InputEventKey and (event as InputEventKey).pressed and(event as InputEventKey).keycode == KEY_SPACE:
		Addscore(10)
