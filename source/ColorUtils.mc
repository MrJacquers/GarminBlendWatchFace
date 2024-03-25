import Toybox.Lang;
import Toybox.Graphics;
import Toybox.System;

class ColorUtils {
    
    // Draw the color gradient from top to bottom. Behaves like dc.DrawLine.
	static function drawGradient(dc, startColor, midColor, endColor, startX, startY, endX, endY) {
		if (midColor < 0) {
			var height = (endY - startY).toFloat();
			for (var i=0; i<=height; i++) {
				var color = lerpColorsCompact(startColor, endColor, i / height);
				dc.setColor(color, 0);
                dc.drawLine(startX, startY + i, endX, startY + i);
			}
			// visual debugging
        	// dc.setColor(Graphics.COLOR_WHITE, 0);
        	// dc.drawLine(startX, startY, startX, endY);
        	// dc.drawLine(endX, startY, endX, endY);
        	// dc.drawLine(startX, startY, endX, startY);
        	// dc.drawLine(startX, endY, endX, endY);
			// end visual debugging
			return;
		}

		var midY = (startY + endY) / 2;
		drawGradient(dc, startColor, -1, midColor, startX, startY, endX, midY);
		drawGradient(dc, midColor, -1, endColor, startX, midY, endX, endY);
	}

	// Draw the color gradient from left to right. Behaves like dc.DrawLine.
	static function drawGradientLR(dc, startColor, midColor, endColor, startX, startY, endX, endY) {
		if (midColor < 0) {
			var width = (endX - startX).toFloat();
			for (var i=0; i<=width; i++) {
                var color = lerpColorsCompact(startColor, endColor, i / width);
				dc.setColor(color, 0);
                dc.drawLine(startX + i, startY, startX + i, endY);
			}
			// visual debugging
        	//dc.setColor(Graphics.COLOR_WHITE, 0);
        	//dc.drawLine(startX, startY, startX, endY);
        	//dc.drawLine(endX, startY, endX, endY);
        	//dc.drawLine(startX, startY, endX, startY);
        	//dc.drawLine(startX, endY, endX, endY);
			// end visual debugging
			return;
		}

		var midX = (startX + endX) / 2;
		drawGradientLR(dc, startColor, -1, midColor, startX, startY, midX, endY);
		drawGradientLR(dc, midColor, -1, endColor, midX, startY, endX, endY);
	}

    // Fill a rectangle with a color gradient from top to bottom. Behaves like draw / fillRectangle.
	static function fillGradient(dc as Dc, startColor, midColor, endColor, x, y, width, height as Float) {
		if (midColor < 0) {
			var x2 = x + width - 1;
			for (var i=0; i<height; i++) {
                var color = lerpColorsCompact(startColor, endColor, i / height);
				dc.setColor(color, 0);
				dc.drawLine(x, y + i, x2, y + i);
			}
			// visual debugging
        	//dc.setColor(Graphics.COLOR_WHITE, 0);
        	//dc.drawRectangle(x, y, width, height);
			// end visual debugging
			return;
		}

        var hh = height / 2;
		var mid = (y + y + height) / 2;
		fillGradient(dc, startColor, -1, midColor, x, y, width, hh);
		fillGradient(dc, midColor, -1, endColor, x, mid, width, hh);
	}

    // Fill a rectangle with a color gradient from top to bottom. Behaves like draw / fillRectangle.
	static function fillGradientLR(dc as Dc, startColor, midColor, endColor, x, y, width as Float, height) {
		if (midColor < 0) {
			var y2 = y + height - 1;
			for (var i=0; i<width; i++) {
                var color = lerpColorsCompact(startColor, endColor, i / width);
				dc.setColor(color, 0);
				dc.drawLine(x + i, y, x + i, y2);
			}
            // visual debugging
            //dc.setColor(Graphics.COLOR_WHITE, 0);
            //dc.drawRectangle(x, y, width, height);
			// end visual debugging
			return;
		}

		var hw = width / 2;
		var mid = (x + x + width) / 2;
		fillGradientLR(dc, startColor, -1, midColor, x, y, hw, height);
		fillGradientLR(dc, midColor, -1, endColor, mid, y, hw, height);
	}

    // Get the interpolated color. If midColor < 0 it's ignored.
	static function getLerpedColor(startColor, midColor, endColor, ratio as Float) {
		if (midColor < 0) {
			return lerpColorsCompact(startColor, endColor, ratio);
		}

		if (ratio < 0.5) {
			return lerpColorsCompact(startColor, midColor, ratio * 2);
		} else if (ratio == 0.5) {
			return midColor;
		} else {
			return lerpColorsCompact(midColor, endColor, ratio * 2);
		}
	}

	// Splits a color into it's RGB components.
	static function getRGB(color as Number) as Array {
		return [(color & 0xFF0000) >> 16, (color & 0x00FF00) >> 8, (color & 0x0000FF)];
	}

    // Converts RGG to a Hex string.
	static function rgbToHex(r, g, b) {
		var color = (r << 16) + (g << 8) + b;
		return color.format("%06X");
	}
	
	// https://gist.github.com/nikolas/b0cce2261f1382159b507dd492e1ceef
	// https://stackoverflow.com/questions/141525/what-are-bitwise-shift-bit-shift-operators-and-how-do-they-work
	static function lerpColors (startRGB as Array, endRGB as Array, ratio as Float) {
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
	static function lerpColorsCompact(startColor as Number, endColor as Number, ratio as Float) {		
		var mask1 = 0xff00ff;
		var mask2 = 0x00ff00; // 0xff00ff00 if alpha is required
		var f2 = (256 * ratio).toNumber();
		var f1 = 256 - f2;
		return (((((startColor & mask1) * f1) + ((endColor & mask1) * f2)) >> 8) & mask1) | (((((startColor & mask2) * f1) + ((endColor & mask2) * f2)) >> 8) & mask2);
	}    
}
