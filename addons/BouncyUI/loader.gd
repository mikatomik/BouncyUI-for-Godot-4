#MIT License
#
#Copyright (c) 2023 MikatomiK
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

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
