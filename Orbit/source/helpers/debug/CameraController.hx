package helpers.debug;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.math.FlxPoint;
import game.GameObjects;
import system.Cameras;

/**
 * Allows for panning and (soon) zooming of the camera
 * Useful for checking parallax effect
 * @author Jonathan Snyder
 */
class CameraController extends FlxBasic {
	
	var initialPressPosition:FlxPoint = FlxPoint.get();
	var initialPressScroll:FlxPoint = FlxPoint.get();
	var difference:FlxPoint = FlxPoint.get();
	var zoomSpeed:Float = .1;

	public function new(?TargetCamera:FlxCamera) {
		super();
		
		if (TargetCamera != null) {
			cameras = [TargetCamera];
			camera = TargetCamera;
		}
		
	}
	
	
	override public function update(elapsed:Float):Void {
		
		// SPACE will enable this controller
		if (FlxG.keys.pressed.SPACE) {
			
			/**
			 * Starts the drag
			 */
			if (FlxG.mouse.justPressed) {
				initialPressPosition.copyFrom(FlxG.mouse.getScreenPosition());
				initialPressScroll.copyFrom(camera.scroll);
			}
			
			/**
			 * Performs drag
			 */
			if (FlxG.mouse.pressed) {
				difference.copyFrom(initialPressPosition).subtractPoint(FlxG.mouse.getScreenPosition());
				difference.scale(1 / camera.zoom);
				camera.scroll.copyFrom(initialPressScroll).addPoint(difference);
			}
			
			/**
			 * Updates camera zoom via mousewheel
			 */
			if (FlxG.mouse.wheel != 0) {
				
				camera.zoom += FlxG.mouse.wheel * (zoomSpeed * (camera.zoom / camera.initialZoom));
				camera.setSize(Std.int(FlxG.width / (camera.zoom / camera.initialZoom)), Std.int(FlxG.height / (camera.zoom / camera.initialZoom)));
				//camera.focusOn(Cameras.debugCam.trueMousePosition);
				
			}
			
			
		}
		
		
		super.update(elapsed);
	}
	
}