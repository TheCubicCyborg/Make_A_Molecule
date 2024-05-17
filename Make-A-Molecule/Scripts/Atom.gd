extends CharacterBody2D

const INIT_SPEED = 100
@export var element: String

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var held: bool = false

func _ready():
	var angle = randf_range(0,360)
	velocity = Vector2(INIT_SPEED * cos(angle), INIT_SPEED * sin(angle))

func _physics_process(delta):
	if(!held):
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.get_normal())
	else:
		position = get_global_mouse_position()


func _on_input_event(viewport, event, shape_idx):
	if !Globals.game_manager.held_atom:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			Globals.game_manager.pick_atom(self)
			Globals.game_manager.just_picked = true
			held = true
			get_node("Atom_Collider").disabled = true
