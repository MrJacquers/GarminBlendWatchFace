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
		/*if (clockTime.sec % 2 == 0) {
			ColorUtils.drawGradient(dc, startColor, midColor, endColor, 0, 0, _devWidth, _devWidth);
		} else {
			ColorUtils.drawGradientLR(dc, startColor, midColor, endColor, 0, 0, _devWidth, _devWidth);
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
			ColorUtils.drawGradient(dc, startColor, midColor, endColor, startX, startY, endX, endY);
		} else {
			ColorUtils.drawGradientLR(dc, startColor, midColor, endColor, startX, startY, endX, endY);
		}

		// create and draw the 'clipping mask'
		dc.setColor(-1, 0);
		dc.drawText(_devCenter, _devCenter, _font, timeString, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

		// more test patterns
		//dc.setColor(0,0);
    	//dc.clear();

    	// test vertical
    	//ColorUtils.drawGradient(dc, 0xff0000, 0xFFFF00, 0x00ff00, 150, 51, 200, 350);
    	//ColorUtils.fillGradient(dc, 0xff0000, 0xFFFF00, 0x00ff00, 210, 51, 50, 300.0);
    
    	// test horizontal
    	//ColorUtils.drawGradientLR(dc, 0xff0000, 0xFFFF00, 0x00ff00, 50, 150, 350, 200);
    	//ColorUtils.fillGradientLR(dc, 0xff0000, 0xFFFF00, 0x00ff00, 50, 210, 300.0, 50);
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
