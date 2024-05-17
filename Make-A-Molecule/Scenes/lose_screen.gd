extends Node2D

func _ready():
	print("lose screen ready")

func _on_texture_button_button_down():
	Globals.switch_scene("res://Scenes/Playtesting.tscn")
