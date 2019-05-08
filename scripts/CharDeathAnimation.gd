extends Node

func play():
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("DeathAnim")

func _on_AnimatedSprite_frame_changed():
	if $AnimatedSprite.frame == 7:
		$AnimatedSprite.visible = false
		$Sprite.visible = true