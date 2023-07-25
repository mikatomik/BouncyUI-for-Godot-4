@tool
extends EditorPlugin

func _enter_tree() -> void:
	var button_icon = get_editor_interface().get_base_control().get_theme_icon("Button", "EditorIcons")
	var label_icon = get_editor_interface().get_base_control().get_theme_icon("Label", "EditorIcons")
	
	var bouncy_button_script = preload("res://addons/BouncyUI/bouncy_button/bouncy_button.gd")
	add_custom_type("BouncyButton", "Button", bouncy_button_script, button_icon)
	
	var bouncy_notifier_script = preload("res://addons/BouncyUI/bouncy_notifier/bouncy_notifier.gd")
	add_custom_type("BouncyNotifier", "Label", bouncy_notifier_script, label_icon)


func _exit_tree() -> void:
	remove_custom_type("BouncyButton")
	remove_custom_type("BouncyNotifier")
