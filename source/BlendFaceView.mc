import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class BlendFaceView extends WatchUi.WatchFace {
	var _font;
	var _devWidth;
	var _devCenter;

	function initialize() {
		WatchFace.initialize();
	}

	// Load your resources here
	function onLayout(dc as Dc) as Void {
		_font = WatchUi.loadResource(Rez.Fonts.id_raj_outline);
		_devWidth = dc.getWidth();
		_devCenter = _devWidth / 2;
	}	

	// Called when this View is brought to the foreground. Restore
	// the state of this View and prepare it to be shown. This includes
	// loading resources into memory.
	function onShow() as Void {}

	// Update the view
	function onUpdate(dc as Dc) as Void {
		dc.setColor(0, 0);
		dc.clear();

		var startColor = 0xFF0000;
		var midColor = 0xffff00;
		var endColor = 0x00FF00;

		// draw background using svg
		//dc.drawBitmap(_devCenter,0,WatchUi.loadResource(Rez.Drawables.gradientBg));

		// Get and format the current time
		var clockTime = System.getClockTime();
		var timeString = Lang.format("$1$$2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d"),]);			 

		// full screen gradient test
		/*if (clockTime.sec %2 == 0) {
			drawGradient(dc, startColor, midColor, endColor, 0, 0, _devWidth, _devWidth);
		} else {
			drawGradientLR(dc, startColor, midColor, endColor, 0, 0, _devWidth, _devWidth);
		}*/
		
		var textDims = dc.getTextDimensions(timeString, _font);
		var textW = textDims[0];
		var textH = textDims[1];
		//System.println("w=" + textW + " h=" + textH);

		var startX = _devCenter - textW / 2;
		var endX = _devCenter + textW / 2 -1;
		var startY = _devCenter - textH / 2 + 1;
		var endY = _devCenter + textH / 2;

		if (clockTime.sec %2 == 0) {
			drawGradient(dc, startColor, midColor, endColor, startX, startY, endX, endY);
		} else {
			drawGradientLR(dc, startColor, midColor, endColor, startX, startY, endX, endY);
		}

		// create and draw the 'clipping mask'
		dc.setColor(-1, 0);
		dc.drawText(_devCenter, _devCenter, _font, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
	}

	// draw the color gradient from top to bottom
	function drawGradient(dc, startColor, midColor, endColor, startX, startY, endX, endY) {
		if (midColor < 0) {
			var height = (endY - startY).toFloat();
			for (var i=0; i<=height; i++) {
					var color = lerpColorsCompact(startColor, endColor, i / height);
					dc.setColor(color, 0);
					dc.drawLine(startX, startY + i, endX, startY + i);
			}
			return;
		}

		var midY = (startY + endY) / 2.0;
		drawGradient(dc, startColor, -1, midColor, startX, startY, endX, midY);
		drawGradient(dc, midColor, -1, endColor, startX, midY, endX, endY);
		
		// visual debugging
		//dc.setColor(Graphics.COLOR_WHITE, 0);
		//dc.drawLine(25, 208, 375, 208);
	}

	// draw the color gradient from left to right
	function drawGradientLR(dc, startColor, midColor, endColor, startX, startY, endX, endY) {
		if (midColor < 0) {
			var width = (endX - startX).toFloat();
			for (var i=0; i<=width; i++) {
					var color = lerpColorsCompact(startColor, endColor, i / width);
					dc.setColor(color, 0);
					dc.drawLine(startX + i, startY, startX + i, endY);
			}
			return;
		}

		var midX = (startX + endX) / 2.0;
		drawGradientLR(dc, startColor, -1, midColor, startX, startY, midX, endY);
		drawGradientLR(dc, midColor, -1, endColor, midX, startY, endX, endY);
		
		// visual debugging
		//dc.setColor(Graphics.COLOR_WHITE, 0);
		//dc.drawLine(208, 25, 208, 375);
	}

	// Splits a color into it's RGB components.
	function getRGB(color as Number) as Array {
		return [(color & 0xFF0000) >> 16, (color & 0x00FF00) >> 8, (color & 0x0000FF)];
	}

	function rgbToHex(r, g, b) {
		var color = (r << 16) + (g << 8) + (b);
		return color.format("%06X");
	}
	
	// https://gist.github.com/nikolas/b0cce2261f1382159b507dd492e1ceef
	// https://stackoverflow.com/questions/141525/what-are-bitwise-shift-bit-shift-operators-and-how-do-they-work
	function lerpColors (startRGB as Array, endRGB as Array, ratio as Float) {
		// interpolate the separate color channels
		var r = (startRGB[0] + ratio * (endRGB[0] - startRGB[0]));
		var g = (startRGB[1] + ratio * (endRGB[1] - startRGB[1]));
		var b = (startRGB[2] + ratio * (endRGB[2] - startRGB[2]));
		return (r.toNumber() << 16) | (g.toNumber() << 8) | (b.toNumber());
	}

	// According to the simulator, this is the fastest way to interpolate between two colors.
	// https://stackoverflow.com/questions/2630925/whats-the-most-effective-way-to-interpolate-between-two-colors-pseudocode-and
	// According to Copilot:
	// This code is written in Monkey C, a language used for developing apps for Garmin devices. The function `lerpColorsCompact` is used to perform a linear interpolation between two colors. This is often used in graphics programming to create smooth transitions between colors.
	// The function takes three arguments: `startColor` and `endColor`, which are the colors to interpolate between, and `ratio`, which is a floating point number between 0 and 1 that determines the weighting of the two colors in the resulting mix.
	// The `mask1` and `mask2` variables are hexadecimal values that represent color masks. A color mask is used to isolate certain color channels (red, green, blue, and possibly alpha) in a color value. In this case, `mask1` is used to isolate the red and blue channels, and `mask2` is used to isolate the green channel.
	// The `f2` variable is calculated by multiplying the `ratio` by 256 and converting the result to a number. The `f1` variable is then calculated as 256 minus `f2`. These variables are used to weight the contribution of the start and end colors to the final color.
	// The `return` statement performs the actual color interpolation. It does this by separately interpolating the red and blue channels (using `mask1`) and the green channel (using `mask2`). The results are then combined using the bitwise OR operator (`|`) to produce the final color.
	// The `>> 8` operation is a right bit shift that effectively divides the result by 256, undoing the earlier multiplication by 256. This is a common technique in fixed-point arithmetic, which is often used in graphics programming for its performance benefits over floating-point arithmetic.
	// The `& mask1` and `& mask2` operations ensure that only the relevant color channels are included in the final color. The other color channels are masked out (set to zero).
	function lerpColorsCompact(startColor as Number, endColor as Number, ratio as Float) {		
		var mask1 = 0xff00ff;
		var mask2 = 0x00ff00; // 0xff00ff00 if alpha is required
		var f2 = (256 * ratio).toNumber();
		var f1 = 256 - f2;
		return (((((startColor & mask1) * f1) + ((endColor & mask1) * f2)) >> 8) & mask1) | (((((startColor & mask2) * f1) + ((endColor & mask2) * f2)) >> 8) & mask2);
	}

	// Called when this View is removed from the screen. Save the
	// state of this View here. This includes freeing resources from
	// memory.
	function onHide() as Void {}

	// The user has just looked at their watch. Timers and animations may be started here.
	function onExitSleep() as Void {}

	// Terminate any active timers and prepare for slow updates.
	function onEnterSleep() as Void {}
}
