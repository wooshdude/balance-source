extends Node2D

func _ready():
	pass

func _on_Area2D_area_entered(area):
	$World/fade/AnimationPlayer.play("fade_to")
	yield(get_node("World/fade/AnimationPlayer"), "animation_finished")
	get_tree().change_scene("res://level_2.tscn")
		

#func playNextAnim():
#	if($World/fade/AnimationPlayer.get_current_animation() == "fade_to"):
#		get_tree().change_scene("res://level_2.tscn")
