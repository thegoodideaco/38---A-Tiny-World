package game;

import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
import game.GameObjects;
import nape.callbacks.CbType;
import nape.geom.Vec2;
import nape.phys.BodyType;
import phys.CbTypes;
import phys.InteractionFilters;
import system.Cameras;
import system.Settings;

/**
 * ...
 * @author Jonathan Snyder
 */
class Baseball extends CircleSprite {
	
	public var trueVelocity(default, null):Vec2;
	//var cbType:CbType;
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/baseball.png");
		//cbType = new CbType();
		
		body.setShapeFilters(InteractionFilters.attracted);
		setDrag(.9999, .9999);
		trueVelocity = body.velocity.copy();
		
		#if FLX_DEBUG
		
		FlxG.console.registerObject("ball", this);
		FlxG.watch.add(this, 'trueVelocity', 'speed');
		#end
		
		circle.cbTypes.add(CbTypes.ball);
	}
	
	
	override public function update(elapsed:Float):Void {
		
		//update true velocity
		trueVelocity.set(body.velocity).angle = -90 * FlxAngle.TO_RAD;
		
		if (FlxG.keys.justPressed.SPACE) {
			bounce();
		}
		
		//TODO: change the logic
		if (FlxG.keys.pressed.LEFT) {
			var force:Vec2 = Vec2.get(50);
			force.rotate(90 - (Cameras.planetCam.angle * FlxAngle.TO_RAD));
			body.applyImpulse(force);
			
			force.dispose();
		}
		
		if (FlxG.keys.pressed.RIGHT) {
			var force:Vec2 = Vec2.get(-50);
			force.rotate(90 - (Cameras.planetCam.angle * FlxAngle.TO_RAD));
			body.applyImpulse(force);
			
			force.dispose();
		}
		//
		
		
		/*if (Math.abs(body.angularVel) > 0){
			//body.angularVel -= (body.angularVel - (body.angularVel * 0.0015));
		}
		
		if (body.velocity.length > 0){
			body.velocity.muleq(1/1.00000001);
		}*/
		
		super.update(elapsed);
	}
	
	/**
	 * Make the ball go slower
	 * @param	Damage
	 */
	override public function hurt(Damage:Float):Void 
	{
		body.velocity.muleq(0.9999);
		//super.hurt(Damage);
	}
	
	public function bounce() 
	{
		var force:Vec2 = body.position.sub(GameObjects.planet.body.position);
			force.length = Settings.jumpStrength;
			body.applyImpulse(force);
			force.dispose();
	}
	
}