extends Node2D

var held_atom
var just_picked = false

const max_atoms = 30
const spawn_freq = 2

var elements = []

@onready var scoreboard = $ScoreBoard
@onready var timer = $Timer
@onready var combo_label = $Combo_label

var comb_atoms = {"carbon" = 0, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 0, "oxygen" = 0, "sodium" = 0}
var atoms_in_comb_space = []
var comb_list = {}
var num_atoms = 0
var time_since_spawn:float = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	print("manager ready")
	Globals.game_manager = self
	init_comb_list()
	init_atoms()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_valid_area() and held_atom and Input.is_action_just_pressed("Click") and !just_picked:
		drop_atom()
	if time_since_spawn > spawn_freq:
		time_since_spawn = 0
		spawn()
	else:
		time_since_spawn += delta
		
	if just_picked:
		just_picked = false

func pick_atom(atom):
	held_atom = atom
	if in_comb_area():
		remove_from_comb(held_atom.element)
		atoms_in_comb_space.erase(held_atom)
	#print(str(comb_atoms))

func drop_atom():
	held_atom.held = false
	held_atom.get_node("Atom_Collider").disabled = false
	if in_comb_area():
		add_to_comb(held_atom.element)
		atoms_in_comb_space.append(held_atom)
	held_atom = null
	#print(str(comb_atoms))

func in_comb_area():
	var mouse_position = get_global_mouse_position()
	if mouse_position.x > 1280 and mouse_position.x < 1920 and mouse_position.y > 0 and mouse_position.y < 500:
		return true

func in_spawn_area():
	var mouse_position = get_global_mouse_position()
	if mouse_position.x > 0 and mouse_position.x < 1280 and mouse_position.y > 0 and mouse_position.y < 1080:
		return true

func in_valid_area():
	return in_comb_area() or in_spawn_area()

func _on_texture_button_button_down():
	if comb_atoms in comb_list:
		var num_atoms = atoms_in_comb_space.size()
		var diff_atoms = get_diff_atoms()
		scoreboard.Addscore((num_atoms*diff_atoms)*10)
		timer.Addtime(num_atoms * diff_atoms)
		#print("Combined: " + comb_list[comb_atoms])
		combo_label.text = "Last Combined:\n" + comb_list[comb_atoms]
		for atom in atoms_in_comb_space:
			comb_atoms[atom.element] -= 1
			atom.free()
		atoms_in_comb_space.clear()
	
func add_to_comb(element:String):
	comb_atoms[element] += 1

func remove_from_comb(element:String):
	comb_atoms[element] -= 1

func spawn():
	var x = randf_range(0,1280)
	var y = randf_range(0,1080)
	var new_atom = elements[randi_range(0,5)].instantiate()
	add_child(new_atom)
	new_atom.position = Vector2(x,y)
	
func get_diff_atoms():
	var diff_atoms = 0
	for atom in comb_atoms:
		if comb_atoms[atom] > 0:
			diff_atoms += 1
	return diff_atoms

func lose():
	Globals.switch_scene("res://Scenes/lose_screen.tscn")

func init_atoms():
	elements.append(preload("res://Scenes/Atom_scenes/Carbon.tscn"))
	elements.append(preload("res://Scenes/Atom_scenes/Chlorine.tscn"))
	elements.append(preload("res://Scenes/Atom_scenes/Hydrogen.tscn"))
	elements.append(preload("res://Scenes/Atom_scenes/Nitrogen.tscn"))
	elements.append(preload("res://Scenes/Atom_scenes/Oxygen.tscn"))
	elements.append(preload("res://Scenes/Atom_scenes/Sodium.tscn"))

func init_comb_list():
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 2, "nitrogen" = 0, "oxygen" = 1, "sodium" = 0}] = "Water" #H2O
	comb_list[{"carbon" = 1, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 0, "oxygen" = 2, "sodium" = 0}] = "Carbon Dioxide" #CO2
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 0, "oxygen" = 2, "sodium" = 0}] = "Oxygen" #O2
	comb_list[{"carbon" = 0, "chlorine" = 1, "hydrogen" = 0, "nitrogen" = 0, "oxygen" = 0, "sodium" = 1}] = "Table Salt" #NaCl
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 0, "oxygen" = 3, "sodium" = 0}] = "Ozone" #O3
	comb_list[{"carbon" = 1, "chlorine" = 3, "hydrogen" = 1, "nitrogen" = 0, "oxygen" = 0, "sodium" = 0}] = "Chloroform" #CHCl3
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 2, "oxygen" = 0, "sodium" = 0}] = "Nitrogen Gas" #N2
	comb_list[{"carbon" = 0, "chlorine" = 2, "hydrogen" = 0, "nitrogen" = 0, "oxygen" = 0, "sodium" = 0}] = "Chlorine Gas" #Cl2
	comb_list[{"carbon" = 0, "chlorine" = 1, "hydrogen" = 1, "nitrogen" = 0, "oxygen" = 0, "sodium" = 0}] = "Hydrochloric Acid" #HCl
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 1, "nitrogen" = 0, "oxygen" = 1, "sodium" = 1}] = "Sodium Hydroxide" #NaOH
	comb_list[{"carbon" = 1, "chlorine" = 0, "hydrogen" = 1, "nitrogen" = 0, "oxygen" = 3, "sodium" = 1}] = "Baking Soda" #NaHCO3
	comb_list[{"carbon" = 0, "chlorine" = 1, "hydrogen" = 0, "nitrogen" = 0, "oxygen" = 1, "sodium" = 1}] = "Bleach" #NaClO
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 2, "oxygen" = 1, "sodium" = 0}] = "Nitrous Oxide" #N2O
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 1, "oxygen" = 3, "sodium" = 1}] = "Sodium Nitrate" #NaNO3
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 1, "oxygen" = 2, "sodium" = 1}] = "Sodium Nitrite" #NaNO2
	comb_list[{"carbon" = 1, "chlorine" = 0, "hydrogen" = 0, "nitrogen" = 1, "oxygen" = 0, "sodium" = 1}] = "Sodium Cyanide" #NaCN
	comb_list[{"carbon" = 6, "chlorine" = 0, "hydrogen" = 12, "nitrogen" = 1, "oxygen" = 6, "sodium" = 0}] = "Glucose" #C6H12O6
	comb_list[{"carbon" = 0, "chlorine" = 0, "hydrogen" = 2, "nitrogen" = 0, "oxygen" = 0, "sodium" = 0}] = "Hydrogen Gas" #H2
