package helpers.debug;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.input.FlxPointer;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import flixel.system.debug.watch.Tracker.TrackerProfile;
import flixel.util.FlxColor;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import system.Cameras;

/**
 * ...
 * @author Jonathan Snyder
 */
class DebugCamera extends FlxCamera {
	
	public var halfSize(get, null):FlxPoint;
	public var scrollOffset(get, null):FlxPoint;
	public var screenCenter(get, null):FlxPoint;
	public var actualScroll(get, null):FlxPoint;
	
	public var matrix(get, null):Matrix;
	public var trueMousePosition:FlxPoint;

	function get_screenCenter():FlxPoint {
		halfSize.copyTo(screenCenter);
		screenCenter.addPoint(scroll);
		return screenCenter;
	}

	public function new(X:Int = 0, Y:Int = 0, Width:Int = 0, Height:Int = 0, Zoom:Float = 0) {
		screenCenter = FlxPoint.get();
		scrollOffset = FlxPoint.get();
		actualScroll = FlxPoint.get();
		super(X, Y, Width, Height, Zoom);
		
		
		trueMousePosition = FlxG.mouse.getPositionInCameraView(this);
		
		
		bgColor = FlxColor.fromString("#4298DF");
		
		#if FLX_DEBUG
		
		FlxG.debugger.addTrackerProfile(new TrackerProfile(DebugCamera, ["halfSize", "scrollOffset", "screenCenter", "actualScroll", "scroll", "matrix"], [FlxCamera]));
		FlxG.console.registerObject("dcam", this);
		FlxG.watch.add(this, "trueMousePosition");
		#end
	}
	
	override public function update(elapsed:Float):Void {
		FlxG.mouse.getPositionInCameraView(this, trueMousePosition);
		trueMousePosition.addPoint(scroll);
		super.update(elapsed);
	}
	
	override function set_zoom(Zoom:Float):Float {
		zoom = (Zoom == 0) ? this.initialZoom : Zoom;
		setScale(zoom, zoom);


		return zoom;
	}
	
	override function updateInternalSpritePositions():Void {
		if (FlxG.renderBlit) {
			if (_flashBitmap != null) {
				regen = regen || (width != buffer.width) || (height != buffer.height);
				
				_flashBitmap.x = -0.5 * width * (scaleX - initialZoom) * FlxG.scaleMode.scale.x;
				_flashBitmap.y = -0.5 * height * (scaleY - initialZoom) * FlxG.scaleMode.scale.y;
			}
		} else {
			if (canvas != null) {
				canvas.x = -0.5 * width * (scaleX - initialZoom) * FlxG.scaleMode.scale.x;
				canvas.y = -0.5 * height * (scaleY - initialZoom) * FlxG.scaleMode.scale.y;
				
				
				canvas.scaleX = totalScaleX;
				canvas.scaleY = totalScaleY;
				
				#if FLX_DEBUG
				if (debugLayer != null) {
					debugLayer.x = canvas.x;
					debugLayer.y = canvas.y;
					
					debugLayer.scaleX = totalScaleX;
					debugLayer.scaleY = totalScaleY;
				}
				#end
			}
		}

	}
	
	override function updateFlashOffset():Void {
		_flashOffset.x = width * 0.5 * totalScaleX;
		_flashOffset.y = height * 0.5 * totalScaleY;
	}
	
	
	override function updateScrollRect():Void {
		var rect:Rectangle = (_scrollRect != null) ? _scrollRect.scrollRect : null;
		
		if (rect != null) {
			rect.x = rect.y = 0;
			rect.width = width * initialZoom * FlxG.scaleMode.scale.x;
			rect.height = height * initialZoom * FlxG.scaleMode.scale.y;
			_scrollRect.scrollRect = rect;
			_scrollRect.x = -0.5 * rect.width;
			_scrollRect.y = -0.5 * rect.height;
		}

	}
	
	
	override public function setScale(X:Float, Y:Float):Void {
		scaleX = X;
		scaleY = Y;
		
		totalScaleX = scaleX * FlxG.scaleMode.scale.x;
		totalScaleY = scaleY * FlxG.scaleMode.scale.y;
		
		if (FlxG.renderBlit) {
			_flashBitmap.scaleX = totalScaleX;
			_flashBitmap.scaleY = totalScaleY;
		}
		else {
			_transform.identity();
			_transform.scale(totalScaleX, totalScaleY);
		}
		
		updateFlashSpritePosition();
		updateScrollRect();
		updateInternalSpritePositions();
		
		
		//scroll.x = scrollOffset.x;
		//this.screenCenter
	}
	
	
	function get_halfSize():FlxPoint {
		return FlxPoint.get(width, height).scale(.5);
	}

	function get_scrollOffset():FlxPoint {
		scrollOffset.x = 0.5 * this.width * (this.zoom - this.initialZoom);
		scrollOffset.y = 0.5 * this.height * (this.zoom - this.initialZoom);
		return scrollOffset;
	}
	
	function get_actualScroll():FlxPoint {

		return actualScroll;
	}
	
	function get_matrix():Matrix {
		return _transform;
	}
	
}