package game;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import phys.CbTypes;
import system.Settings;

/**
 * ...
 * @author Jonathan Snyder
 */
class Planet extends CircleSprite {
	public var radius(default, null):Float = 1000;

	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/planet.png", radius, BodyType.KINEMATIC);
		
		circle.cbTypes.add(CbTypes.cloud);
		circle.userData.sprite = this;
		setBodyMaterial(.3);
		
		
		#if FLX_DEBUG
		
		FlxG.console.registerObject("planet", this);
		
		#end
	}
	
	
}