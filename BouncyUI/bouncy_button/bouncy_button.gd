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
## If scaled_font_size is big enough to cause your button size to adjust,
## it may cause other UI elements to be pushed around if they are in a shared container.
## To get around this, increase the button's custom minimum size, or decrease scaled_font_size
## until the button size no longer adjusts itself during text scaling.
## This will likely need tweaked to suit your particular font.
@export var scaled_font_size : int = 35 :
	set(value):
		scaled_font_size = value
		if Engine.is_editor_hint() and view_scaled_font_size:
			set("theme_override_font_sizes/font_size", value)
	get:
		return scaled_font_size
		
## Preview the scaled font size value in the editor.
## If animation_preview_enabled is true, the animation will play in editor when toggling this setting.
## Will be disabled at runtime.
@export var view_scaled_font_size : bool = false :
	set(value):
		view_scaled_font_size = value
		if value:
			if animation_preview_enabled:
				tween_font_size_up()
			else:
				set("theme_override_font_sizes/font_size", scaled_font_size)
		else:
			if animation_preview_enabled:
				tween_font_size_down()
			else:
				set("theme_override_font_sizes/font_size", base_font_size)
			
	get:
		return view_scaled_font_size

##Amount of time the text will take to scale up in seconds.
@export var scale_up_time : float = 0.5

##Amount of time the text will take to scale down in seconds.
@export var scale_down_time : float = 0.1

##Curve to use during scaling up of the text.
@export var scale_up_curve_type : TRANSITION_TYPE = TRANSITION_TYPE.BOUNCE

##Curve to use during scaling down of the text.
@export var scale_down_curve_type : TRANSITION_TYPE = TRANSITION_TYPE.LINEAR
	
enum TRANSITION_TYPE {
	LINEAR,##Scale using Tween.TRANS_LINEAR.
	BOUNCE,##Scale using Tween.TRANS_BOUNCE. If the Base Font Size and Scaled Font Size are too close, this won't be perceivable. Additionally, if the Scale Speed is too low it may also be unperceivable.
	SPRING, ##Scale using Tween.TRANS_SPRING. If the Base Font Size and Scaled Font Size are too close, this won't be perceivable. Additionally, if the Scale Speed is too low it may also be unperceivable.
	ELASTIC ## Scale using Tween.TRANS_ELASTIC.
}

##Ease type to be used when scaling up.
@export var scale_up_ease_type : EASE_TYPE = EASE_TYPE.EASE_OUT

##Ease type to be used when scaling down.
@export var scale_down_ease_type : EASE_TYPE = EASE_TYPE.EASE_OUT


enum EASE_TYPE {
	EASE_IN_OUT,##Scale using Tween.EASE_IN_OUT.
	EASE_OUT_IN,##Scale using Tween.EASE_OUT_IN.
	EASE_IN,##Scale using Tween.EASE_IN.
	EASE_OUT##Scale using Tween.EASE_OUT.
}

##Button will grab focus and animation will happen when mouse
##is hovered over the button.
@export var grab_focus_on_mouse_enter : bool = true

##Release focus of the button when the mouse leaves it without clicking.
##Looks nice for desktop specific platforms, but since no button will have focus
##after this is triggered, it will strand controller and keyboard users without
##a way to access the UI nodes unless you manually call grab_focus() on another node.
@export var release_focus_on_mouse_exit : bool = false

##If enabled, preview tween in editor when "View Scaled Font Size" is toggled.
@export var animation_preview_enabled : bool = false

var active_tween : Tween = null #Track the active tween so we can kill it before starting a new one

func _enter_tree() -> void:
	if !focus_entered.is_connected(_on_gained_focus):
		focus_entered.connect(_on_gained_focus)
	if !focus_exited.is_connected(_on_lost_focus):
		focus_exited.connect(_on_lost_focus)
	if !mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if !mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
		
	if Engine.is_editor_hint():
		set("theme_override_font_sizes/font_size", true)
		set("theme_override_font_sizes/font_size", base_font_size)
		set("custom_minimum_size", Vector2(300, 60))
		set("text", "BouncyButton")
		
	elif !Engine.is_editor_hint():
		if animation_preview_enabled:
			animation_preview_enabled = false
		
		if view_scaled_font_size:
			view_scaled_font_size = false


func _on_gained_focus() -> void:
	tween_font_size_up()

func _on_lost_focus() -> void:
	tween_font_size_down()
	
func tween_font_size_down() -> void:
	if active_tween:
		active_tween.kill()
	var tw = get_tree().create_tween()
	
	match scale_down_curve_type:
		TRANSITION_TYPE.LINEAR: tw.set_trans(Tween.TRANS_LINEAR)
		TRANSITION_TYPE.BOUNCE: tw.set_trans(Tween.TRANS_BOUNCE)
		TRANSITION_TYPE.SPRING: tw.set_trans(Tween.TRANS_SPRING)
		TRANSITION_TYPE.ELASTIC: tw.set_trans(Tween.TRANS_ELASTIC)
	match scale_down_ease_type:
		EASE_TYPE.EASE_IN_OUT: tw.set_ease(Tween.EASE_IN_OUT)
		EASE_TYPE.EASE_OUT_IN: tw.set_ease(Tween.EASE_OUT_IN)
		EASE_TYPE.EASE_IN: tw.set_ease(Tween.EASE_IN)
		EASE_TYPE.EASE_OUT: tw.set_ease(Tween.EASE_OUT)
		
	tw.tween_property(self, "theme_override_font_sizes/font_size", base_font_size, scale_down_time)
	active_tween = tw

func tween_font_size_up() -> void:
	if active_tween:
		active_tween.kill()
	var tw = get_tree().create_tween()
	
	match scale_up_curve_type:
		TRANSITION_TYPE.LINEAR:  tw.set_trans(Tween.TRANS_LINEAR)
		TRANSITION_TYPE.BOUNCE:  tw.set_trans(Tween.TRANS_BOUNCE)
		TRANSITION_TYPE.SPRING:  tw.set_trans(Tween.TRANS_SPRING)
		TRANSITION_TYPE.ELASTIC: tw.set_trans(Tween.TRANS_ELASTIC)
	match scale_up_ease_type:
		EASE_TYPE.EASE_IN_OUT: tw.set_ease(Tween.EASE_IN_OUT)
		EASE_TYPE.EASE_OUT_IN: tw.set_ease(Tween.EASE_OUT_IN)
		EASE_TYPE.EASE_IN:     tw.set_ease(Tween.EASE_IN)
		EASE_TYPE.EASE_OUT:    tw.set_ease(Tween.EASE_OUT)
		
	tw.tween_property(self, "theme_override_font_sizes/font_size", scaled_font_size, scale_up_time)
	active_tween = tw

func _on_mouse_entered() -> void:
	if grab_focus_on_mouse_enter:
		self.grab_focus()

func _on_mouse_exited() -> void:
	if release_focus_on_mouse_exit:
		self.release_focus()
