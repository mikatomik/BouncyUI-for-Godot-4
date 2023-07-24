@tool
extends Button
class_name BouncyButton

## Base font size in points. Used when NOT in focus.
## This will likely need tweaked to suit your particular font.
@export var base_font_size : int = 15 :
	set(value):
		base_font_size = value
		set("theme_override_font_sizes/font_size", value)
	get:
		return base_font_size

## Scaled font size in points. Used when IN focus.
## If the scaled font size is big enough to cause your button size to adjust,
## it may cause other UI elements to be pushed around if they are in a shared container.
## To get around this, increase the button's custom minimum size until the button size
## no longer adjusts itself during text scaling.
## This will likely need tweaked to suit your particular font.
@export var scaled_font_size : int = 35 :
	set(value):
		scaled_font_size = value
	get:
		return scaled_font_size
		
## Preview the scaled font size value in the editor.
## Will be disabled at runtime.
@export var view_scaled_font_size : bool = false :
	set(value):
		view_scaled_font_size = value
		if value:
			set("theme_override_font_sizes/font_size", scaled_font_size)
		else:
			set("theme_override_font_sizes/font_size", base_font_size)
			
	get:
		return view_scaled_font_size

##Speed at which the font will scale up in seconds.
@export var scale_speed : float = 0.1

##Curve to use during scaling up of the text.
@export var scale_up_curve_type : TRANSITION_TYPE = TRANSITION_TYPE.LINEAR

##Curve to use during scaling down of the text.
@export var scale_down_curve_type : TRANSITION_TYPE = TRANSITION_TYPE.LINEAR
	
enum TRANSITION_TYPE {
	LINEAR,##Scale using Tween.TRANS_LINEAR.
	BOUNCE,##Scale using Tween.TRANS_BOUNCE. If the Base Font Size and Scaled Font Size are too close, this won't be perceivable. Additionally, if the Scale Speed is too low it may also be unperceivable.
	SPRING ##Scale using Tween.TRANS_SPRING. If the Base Font Size and Scaled Font Size are too close, this won't be perceivable. Additionally, if the Scale Speed is too low it may also be unperceivable.
}

##Ease type to be used when scaling up.
@export var scale_up_ease_type : EASE_TYPE = EASE_TYPE.EASE_OUT

##Ease type to be used when scaling down.
@export var scale_down_ease_type : EASE_TYPE = EASE_TYPE.EASE_OUT


enum EASE_TYPE {
	EASE_IN_OUT,##Scale using Tween.EASE_IN_OUT.
	EASE_OUT_IN,##Scale using Tween.EASE_OUT_IN.
	EASE_IN,##Scale using TWEEN.EASE_IN.
	EASE_OUT##Scale using TWEEN.EASE_OUT.
}

##Release focus of the button when the mouse leaves it without clicking.
##Looks nice for PC specific platforms, but since no button will have focus
##after this is triggered, it will strand controller and keyboard users without
##a way to access the UI nodes unless you manually call grab_focus() on another node.
@export var release_focus_on_mouse_exit : bool = false

func _enter_tree() -> void:
	if !focus_entered.is_connected(_on_gained_focus):
		focus_entered.connect(_on_gained_focus)
	if !focus_exited.is_connected(_on_lost_focus):
		focus_exited.connect(_on_lost_focus)
	if !mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if !mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
		
	set("theme_override_font_sizes/font_size", true)
	set("theme_override_font_sizes/font_size", base_font_size)
	set("custom_minimum_size", Vector2(300, 60))
	
	if view_scaled_font_size:
		view_scaled_font_size = false

func _on_gained_focus() -> void:
	tween_font_size_up()

func _on_lost_focus() -> void:
	tween_font_size_down()
	
func tween_font_size_down() -> void:
	var tw = get_tree().create_tween()
	
	match scale_down_curve_type:
		TRANSITION_TYPE.LINEAR: tw.set_trans(Tween.TRANS_LINEAR)
		TRANSITION_TYPE.BOUNCE: tw.set_trans(Tween.TRANS_BOUNCE)
		TRANSITION_TYPE.SPRING: tw.set_trans(Tween.TRANS_SPRING)
	match scale_down_ease_type:
		EASE_TYPE.EASE_IN_OUT: tw.set_ease(Tween.EASE_IN_OUT)
		EASE_TYPE.EASE_OUT_IN: tw.set_ease(Tween.EASE_OUT_IN)
		EASE_TYPE.EASE_IN: tw.set_ease(Tween.EASE_IN)
		EASE_TYPE.EASE_OUT: tw.set_ease(Tween.EASE_OUT)
		
	tw.tween_property(self, "theme_override_font_sizes/font_size", base_font_size, scale_speed)

func tween_font_size_up() -> void:
	var tw = get_tree().create_tween()
	
	match scale_up_curve_type:
		TRANSITION_TYPE.LINEAR: tw.set_trans(Tween.TRANS_LINEAR)
		TRANSITION_TYPE.BOUNCE: tw.set_trans(Tween.TRANS_BOUNCE)
		TRANSITION_TYPE.SPRING: tw.set_trans(Tween.TRANS_SPRING)
	match scale_up_ease_type:
		EASE_TYPE.EASE_IN_OUT: tw.set_ease(Tween.EASE_IN_OUT)
		EASE_TYPE.EASE_OUT_IN: tw.set_ease(Tween.EASE_OUT_IN)
		EASE_TYPE.EASE_IN: tw.set_ease(Tween.EASE_IN)
		EASE_TYPE.EASE_OUT: tw.set_ease(Tween.EASE_OUT)
		
	tw.tween_property(self, "theme_override_font_sizes/font_size", scaled_font_size, scale_speed)

func _on_mouse_entered() -> void:
	self.grab_focus()

func _on_mouse_exited() -> void:
	if release_focus_on_mouse_exit:
		self.release_focus()
