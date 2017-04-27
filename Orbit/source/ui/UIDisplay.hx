package ui;

import flixel.math.FlxMath;
import flixel.math.FlxMath;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxBitmapText;
import flixel.group.FlxGroup;
import system.Cameras;
import system.PlayerData;

/**
 * ...
 * @author Jonathan Snyder
 */
class UIDisplay extends FlxGroup {

	var font:FlxBitmapFont;
	public var distanceText:FlxBitmapText;
	public var degreesText:FlxBitmapText;

	public function new() {
		super();
		cameras = [Cameras.uiCam];
		
		
		font = FlxBitmapFont.fromAngelCode("assets/fonts/ui-font.png", "assets/fonts/ui-font.xml");

		add(distanceText = new FlxBitmapText(font));
		add(degreesText = new FlxBitmapText(font));
		
		//add(new FlxSprite().makeGraphic(100, 100));
		
		
		distanceText.text = "12345";
		degreesText.text = "123";
		degreesText.alignment = "right";
		degreesText.x = FlxG.width - degreesText.width;
	}
	
	
	override public function add(Object:FlxBasic):FlxBasic {
		Object.cameras = cameras;
		return super.add(Object);
	}
	
	
	override public function update(elapsed:Float):Void {
		
		
		distanceText.text = Std.string(FlxMath.roundDecimal(PlayerData.totalDistance, 2)) + '“';
		degreesText.text = Std.string(Std.int(PlayerData.totalDegrees)) + "˚";
		reposition();
		
		super.update(elapsed);
	}
	
	function reposition() {
		var padding:Float = 15;
		distanceText.setPosition(padding, padding);
		degreesText.setPosition(FlxG.width - degreesText.width - padding, padding);
	}
	
}