package game;

import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.system.FlxAssets.FlxGraphicAsset;
import game.GameObjects;
import nape.geom.Vec2;
import phys.CbTypes;
import phys.InteractionFilters;
import system.Cameras;
import system.Settings;

/**
 * ...
 * @author Jonathan Snyder
 */
class Baseball extends CircleSprite {
	
	var _oldAngle(default, null):Float = 0;
	public var orbitAngle(get, null):Float;
	public var velocityAngle(get, null):Float;
	public var orbitDegrees(get, null):Float;
	public var trueVelocity(default, null):Vec2;
	//var cbType:CbType;
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/ball.png");
		//cbType = new CbType();
		
		
		setDrag(.9999, .9999);
		trueVelocity = body.velocity.copy();
		
		body.setShapeFilters(InteractionFilters.attracted);
		circle.cbTypes.add(CbTypes.ball);
		
		#if FLX_DEBUG
		//Add debugging

		FlxG.console.registerObject("ball", this);

		FlxG.watch.add(this, 'orbitAngle', 'radians');
		FlxG.watch.add(this, 'orbitDegrees', 'degrees');
		#end
		
	}
	
	
	override public function update(elapsed:Float):Void {
		
		//update true velocity
		var totalRadians:Float = body.position.sub(GameObjects.planet.body.position, true).angle - _oldAngle;
		var circumfrence:Float = 2 * body.position.sub(GameObjects.planet.body.position, true).length * Math.PI;
		
		var distanceMoved:Float = ((totalRadians * FlxAngle.TO_DEG) / 360) * circumfrence;
		trueVelocity.x += distanceMoved;
		
		_oldAngle = totalRadians;
		
		
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
		
		super.update(elapsed);
	}
	
	/**
	 * Make the ball go slower
	 * @param	Damage
	 */
	override public function hurt(Damage:Float):Void {
		body.velocity.muleq(0.9999);
		//super.hurt(Damage);
	}
	
	//Adds bounce to the ball
	public function bounce() {
		var force:Vec2 = body.position.sub(GameObjects.planet.body.position);
		force.length = Settings.jumpStrength;
		body.applyImpulse(force);
		force.dispose();
	}
	
	//Get angle in RADIANS around the planet
	function get_orbitAngle():Float {
		return  (Math.PI / 2) - body.position.sub(GameObjects.planet.body.position, true).angle;

	}

	//Get angle in DEGREES around the planet
	function get_orbitDegrees():Float {
		return orbitAngle * FlxAngle.TO_DEG;
	}
	
	//Returns the angle in RADIANS of current velocity
	function get_velocityAngle():Float {
		return body.velocity.angle;
	}
}