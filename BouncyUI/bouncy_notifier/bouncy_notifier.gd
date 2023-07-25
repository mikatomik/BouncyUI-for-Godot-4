#
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
extends Label
class_name BouncyNotifier

const default_text : String = "You forgot to set the text!"
const default_font_size : int = 15

## How much to scale during animation.
@export var scale_amount : Vector2 = Vector2(2.5,2.5)

## Curve to use when scaling up.
@export var scale_curve_type : TRANSITION_TYPE = TRANSITION_TYPE.BOUNCE

## Ease type to be applied on scale curve.
@export var scale_ease_type : EASE_TYPE = EASE_TYPE.EASE_OUT

## Determines where the center of the scaling is.
@export var scale_origin : SCALE_ORIGIN = SCALE_ORIGIN.CENTER

## Amount of time for scale to happen.
@export var scale_duration : float = 0.5

## Amount of time the notification moves for
@export var move_duration : float = 1.0

## Direction notification moves from it's start point over it's lifetime.
@export var move_direction : Vector2 = Vector2.UP

## Transition to use during translation of BouncyNotifier.
@export var move_transition_type : TRANSITION_TYPE = TRANSITION_TYPE.LINEAR

## Ease type to be applied to the translation curve.
@export var move_ease_type : EASE_TYPE = EASE_TYPE.EASE_OUT

enum TRANSITION_TYPE {
	LINEAR,##Scale using Tween.TRANS_LINEAR.
	BOUNCE,##Scale using Tween.TRANS_BOUNCE. If the Base Font Size and Scaled Font Size are too close, this won't be perceivable. Additionally, if the Scale Speed is too low it may also be unperceivable.
	SPRING, ##Scale using Tween.TRANS_SPRING. If the Base Font Size and Scaled Font Size are too close, this won't be perceivable. Additionally, if the Scale Speed is too low it may also be unperceivable.
	ELASTIC ## Scale using Tween.TRANS_ELASTIC.
}

enum SCALE_ORIGIN {
	TOP_LEFT, ## Scale from Top Left of BouncyNotifier bounding box.
	BOTTOM_LEFT, ## Scale from Bottom Left of BouncyNotifier bounding box.
	TOP_RIGHT, ## Scale from Top Right of BouncyNotifier bounding box.
	BOTTOM_RIGHT, ## Scale from Bottom Right of BouncyNotifier bounding box.
	CENTER ## Scale from Center of BouncyNotifier bounding box.
}

enum EASE_TYPE {
	EASE_IN_OUT,##Scale using Tween.EASE_IN_OUT.
	EASE_OUT_IN,##Scale using Tween.EASE_OUT_IN.
	EASE_IN,##Scale using Tween.EASE_IN.
	EASE_OUT##Scale using Tween.EASE_OUT.
}

func set_scale_params(final_scale : Vector2 = Vector2(2.0,2.0), 
					duration : float = 1.0, origin : SCALE_ORIGIN = SCALE_ORIGIN.CENTER,
					scale_trans : TRANSITION_TYPE = TRANSITION_TYPE.BOUNCE,
					ease : EASE_TYPE = EASE_TYPE.EASE_OUT) -> BouncyNotifier:
	scale_amount = final_scale
	scale_duration = duration
	scale_curve_type = scale_trans
	scale_ease_type = ease
	scale_origin = origin
	return self

func set_text_params(message : String = default_text, font_size : int = default_font_size, theme : Theme = null) ->  BouncyNotifier:
	if theme:
		self.set("theme", theme)
	self.set_text(message)
	set("theme_override_font_sizes/font_size", font_size)
	return self
	
func set_translation_params(start_pos : Vector2, move_dir : Vector2 = Vector2.UP, 
							duration : float = 1.0,
							move_trans : TRANSITION_TYPE = TRANSITION_TYPE.LINEAR,
							ease : EASE_TYPE = EASE_TYPE.EASE_OUT) -> BouncyNotifier:
	self.global_position = start_pos
	self.global_position = Vector2(self.global_position.x - (size.x/2.0), self.global_position.y - (size.y/2.0))
	move_direction = move_dir
	move_duration = duration
	move_transition_type = move_trans
	move_ease_type = ease
	return self

func _process(_delta: float) -> void:
	var bound_size : Vector2 = get("size")
	match scale_origin:
		SCALE_ORIGIN.TOP_LEFT     : self.pivot_offset = Vector2.ZERO
		SCALE_ORIGIN.BOTTOM_LEFT  : self.pivot_offset = Vector2(0, bound_size.y)
		SCALE_ORIGIN.TOP_RIGHT    : self.pivot_offset = Vector2(bound_size.x, 0)
		SCALE_ORIGIN.BOTTOM_RIGHT : self.pivot_offset = Vector2(bound_size.x, bound_size.y)
		SCALE_ORIGIN.CENTER       : self.pivot_offset = Vector2(bound_size.x/2, bound_size.y/2)
		

func start() -> void:
	if !Engine.is_editor_hint():
		var tw = get_tree().create_tween()
		tw.set_parallel(true)
		tw.finished.connect(animation_ended)
	
		match scale_curve_type:
			TRANSITION_TYPE.LINEAR : tw.set_trans(Tween.TRANS_LINEAR)
			TRANSITION_TYPE.BOUNCE : tw.set_trans(Tween.TRANS_BOUNCE)
			TRANSITION_TYPE.SPRING : tw.set_trans(Tween.TRANS_SPRING)
			TRANSITION_TYPE.ELASTIC: tw.set_trans(Tween.TRANS_ELASTIC)
		
		match scale_ease_type:
			EASE_TYPE.EASE_IN_OUT  : tw.set_ease(Tween.EASE_IN_OUT)
			EASE_TYPE.EASE_OUT_IN  : tw.set_ease(Tween.EASE_OUT_IN)
			EASE_TYPE.EASE_IN      : tw.set_ease(Tween.EASE_IN)
			EASE_TYPE.EASE_OUT     : tw.set_ease(Tween.EASE_OUT)
		
		tw.tween_property(self, "scale", scale_amount, scale_duration)
		
		match move_transition_type:
			TRANSITION_TYPE.LINEAR : tw.set_trans(Tween.TRANS_LINEAR)
			TRANSITION_TYPE.BOUNCE : tw.set_trans(Tween.TRANS_BOUNCE)
			TRANSITION_TYPE.SPRING : tw.set_trans(Tween.TRANS_SPRING)
			TRANSITION_TYPE.ELASTIC: tw.set_trans(Tween.TRANS_ELASTIC)
			
		match move_ease_type:
			EASE_TYPE.EASE_IN_OUT: tw.set_ease(Tween.EASE_IN_OUT)
			EASE_TYPE.EASE_OUT_IN: tw.set_ease(Tween.EASE_OUT_IN)
			EASE_TYPE.EASE_IN    : tw.set_ease(Tween.EASE_IN)
			EASE_TYPE.EASE_OUT   : tw.set_ease(Tween.EASE_OUT)
		
		tw.tween_property(self, "position", self.global_position + (move_direction.normalized() * randf_range(100, 200)), move_duration)

func _enter_tree() -> void:
	set("text", default_text)
	set("horizontal_alignment", HORIZONTAL_ALIGNMENT_CENTER)
	set("vertical_alignment", VERTICAL_ALIGNMENT_CENTER)
	set("theme_override_font_sizes/font_size", true)
	set("theme_override_font_sizes/font_size", default_font_size)
	self.pivot_offset = size/2.0
	self.global_position = Vector2(self.global_position.x - (size.x/2.0), self.global_position.y - (size.y/2.0))

func animation_ended() -> void:
	self.queue_free()
