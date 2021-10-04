extends Node2D

var levels = [preload("res://level_1.tscn"),
preload("res://level_2.tscn"),
preload("res://level_3.tscn"),
preload("res://level_4.tscn"),
preload("res://level_5.tscn"),
preload("res://level_6.tscn"),
preload("res://level_7.tscn"),
preload("res://level_8.tscn"),
preload("res://level_9.tscn"),
preload("res://level_10.tscn"),]

# Called when the node enters the scene tree for the first time.
func _ready():
	var levels_instance = levels.instance()
	add_child(levels_instance[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
