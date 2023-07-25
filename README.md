# BouncyUI-for-Godot-4
Easy, simple UI animation. Note this is a work in progress and currently contains only two nodes.

## How to install:

### Asset Library:
* Coming soon

### Manual installation:
* Clone or download this repository
* Copy the folder 'addons/BouncyUI' in your 'res://addons/' folder
* Enable BouncyUI in `Project -> Project Settings -> Plugins`

## Currently Included Nodes:
* BouncyButton
  - A regular button, but with built in and configurable animations.
	![](https://github.com/mikatomik/BouncyUI-for-Godot-4/blob/master/screenshots/bouncybuttonpreview.gif)
* BouncyNotifier
  - A label with built in and configurable animations to be used for short screen notifications
	like damage indicators.
	![](https://github.com/mikatomik/BouncyUI-for-Godot-4/blob/master/screenshots/bouncynotifierpreview.gif)

## How to use:
* BouncyButton
  - Just search for BouncyButton in the add new node dialog. Add a new button. It works out of the box
like any other button, but you'll notice extra paramters in the inspector.
![](https://github.com/mikatomik/BouncyUI-for-Godot-4/blob/master/screenshots/bouncybuttoninspector.png)
The "bounce" works by scaling your button font size. Toggle "Animation Preview Enabled", then toggle
"View Scaled Font Size." You should see the animations work in the editor. You can tweak the animation
using the other controls in the inspector panels. Just watch out, if you are using buttons inside of a container and the
scaled font size is too big, it will cause the bounding box of the button to grow and push the other buttons around. To 
avoid this behavior, either decrease scaled font size or increase "custom_minimum_size."

* BouncyNotifier
  - This node is NOT meant to be used in the editor, but rather created in code. It is a "fire and forget" object.
First, when you want to have a BouncyNotifier fire off, make a new one.


## License
MIT
