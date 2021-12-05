this requires love2d (https://love2d.org/)
# love2d-egpdesigner
## a helper program that allows you to draw polygons and export to [wiremod](https://github.com/wiremod/wire) EGP code
 
 
 replace background.png (in egpdesigner/res folder) to change the background while drawing (has to be 512 x 512)
 this tool was made by lokachop
 contact Lokachop#5862 if you have any issues, enjoy!


CONTROLS:

	space; toggle drawmode
	w; advance 1 object forward
	s; advance 1 object backwards (make sure to not be on object 0 or less than 0)
	
	while drawmode is off:
		the top bar is to pick colour out of the hsv2rgb thing
		the middle bar is to pick brightness
		the bottom bar is to pick saturation
		
		just click on the bars
	while drawmode is on:
		mouseclick to add a point to the current polygon
	
	buttons:
		Transparency: makes all the polygons a bit transparent to help with copying off the background
		Export!: exports the current polygons as an e2 egp file, output is C:\Users\[your user]\AppData\Roaming\LOVE\egpdesigner
