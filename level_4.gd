extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	$World/fade/AnimationPlayer.play("fade_to")
	yield(get_node("World/fade/AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://level_5.tscn")
