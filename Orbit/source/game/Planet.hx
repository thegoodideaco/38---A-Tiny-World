package game;

import flixel.FlxG;
import flixel.addons.nape.FlxNapeSpace;
import flixel.math.FlxAngle;
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
	
	
	override public function update(elapsed:Float):Void {
		
		attract(2650 / 2);
		
		//if (body.angularVel > 0) {
		//body.angularVel /= 1.5;
		//}
		//
		//var turnStrength:Float = 1;
		//if (FlxG.keys.pressed.RIGHT) {
		//body.angularVel += (turnStrength * FlxAngle.TO_RAD);
		////body.applyAngularImpulse(turnStrength * FlxAngle.TO_RAD);
		//}
		//
		//if (FlxG.keys.pressed.LEFT) {
		//body.angularVel -= (turnStrength * FlxAngle.TO_RAD);
		//}
		
		super.update(elapsed);
	}
	
	
	public function attract(Radius:Float):Void {
		
		/**
		 * Apply a force towards the center of each body within range
		 */
		var b:Body = GameObjects.ball.body;
		var f:Vec2 = GameObjects.planet.body.position.sub(GameObjects.ball.body.position);
		f.length = Settings.gravityForce;
		b.force.set(f);
	}
	
}