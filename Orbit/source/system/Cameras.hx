package system;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;
import helpers.debug.DebugCamera;

/**
 * ...
 * @author Jonathan Snyder
 */
class Cameras {
	public static var skyCam:FlxCamera;
	public static var planetCam:FlxCamera;
	public static var debugCam:DebugCamera;
	public static var uiCam:FlxCamera;
	
	public static function init():Void {
		
		planetCam = new FlxCamera();
		skyCam = new FlxCamera();
		uiCam = new FlxCamera();
		
		
		planetCam.bgColor = skyCam.bgColor = uiCam.bgColor = FlxColor.TRANSPARENT;
		planetCam.antialiasing = skyCam.antialiasing = uiCam.antialiasing = true;
		
		var defaultCam:FlxCamera = FlxG.camera;
		defaultCam.visible = false;
		
		
		//FlxG.camera.antialiasing = true;
		var camSize:Int = Std.int(Math.sqrt(FlxG.width * FlxG.width + FlxG.height * FlxG.height));
		planetCam.setSize(camSize, camSize);
		planetCam.setPosition((FlxG.width / 2) - (camSize / 2), (FlxG.height / 2) - (camSize / 2));
		
		FlxG.cameras.add(skyCam);
		FlxG.cameras.add(planetCam);
		FlxG.cameras.add(uiCam);
		
		
		#if FLX_DEBUG
		debugCam = new DebugCamera();
		
		FlxG.console.registerObject("dcam", debugCam);
		#end
	}
	
	
	#if FLX_DEBUG

	public static function toggleDebugView() {
		if (FlxG.cameras.list.indexOf(debugCam) != -1) {
			FlxG.cameras.remove(debugCam, false);
		} else {
			FlxG.cameras.add(debugCam);
		}
		//debugCam.visible = !debugCam.visible;
	}
	
	#end
}