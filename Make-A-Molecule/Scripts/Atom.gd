extends CharacterBody2D

const INIT_SPEED = 200

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
