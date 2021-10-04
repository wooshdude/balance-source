extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$menu.visible = false
	$fade/AnimationPlayer.play("fade_from")
	yield(($fade/AnimationPlayer), "animation_finished")
	$fade/ColorRect.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Camera2D.global_position = ($buttons/center.global_position + get_global_mouse_position()) * 0.05
	$buttons/playButton.rect_global_position = lerp($buttons/button1place.global_position, get_global_mouse_position(), 0.05)
	$buttons/menuButton.rect_global_position = lerp($buttons/buttonplaec.global_position, get_global_mouse_position(), 0.05)
	
	if $buttons/playButton.pressed:
		$fade/ColorRect.visible = true
		$fade/AnimationPlayer.play("fade_to")
		yield(($fade/AnimationPlayer), "animation_finished")
		get_tree().change_scene("res://level_1.tscn")
		$fade/ColorRect.visible = false
		
	if $buttons/menuButton.pressed:
		$fade/ColorRect.visible = true
		$fade/AnimationPlayer.play("fade_to")
		yield(($fade/AnimationPlayer), "animation_finished")
		$buttons.visible = false
		$menu.visible = true
		$fade/AnimationPlayer.play("fade_from")
		yield(($fade/AnimationPlayer), "animation_finished")
		$fade/ColorRect.visible = false
		
	if $menu/Button.pressed:
		$fade/ColorRect.visible = true
		$fade/AnimationPlayer.play("fade_to")
		yield(($fade/AnimationPlayer), "animation_finished")
		$buttons.visible = true
		$menu.visible = false
		$fade/AnimationPlayer.play("fade_from")
		yield(($fade/AnimationPlayer), "animation_finished")
		$fade/ColorRect.visible = false
