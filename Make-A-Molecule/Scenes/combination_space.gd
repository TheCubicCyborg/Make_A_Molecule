extends Node2D

var containted_atoms = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_static_body_2d_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#if Globals.game_manager.held_atom or Globals.game_manager.just_placed:
			#print("placing")
		#else:
			#print("taking")
	pass
