package game;

import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.system.FlxAssets.FlxGraphicAsset;
import game.GameObjects;
import nape.geom.Vec2;
import phys.CbTypes;
import phys.InteractionFilters;
import system.Cameras;
import system.PlayerData;
import system.Settings;

/**
 * ...
 * @author Jonathan Snyder
 */
class Baseball extends CircleSprite {
	public var circumfrence(default, null):Float;
	public var totalDistance(default, null):Float = 0;
	public var totalDegrees(get, null):Float;
	var _oldDegrees(default, null):Float = 360;
	public var orbitAngle(get, null):Float;
	public var velocityAngle(get, null):Float;
	public var orbitDegrees(get, null):Float;
	public var trueVelocity(default, null):Vec2;
	public function new(X:Float = 0, Y:Float = 0) {
		super(X, Y, "assets/images/ball.png");
		//cbType = new CbType();
		
		
		setDrag(.9999, .9999);
		trueVelocity = body.velocity.copy();
		
		body.setShapeFilters(InteractionFilters.attracted);
		circle.cbTypes.add(CbTypes.ball);
		circumfrence = 2 * GameObjects.planet.circle.radius * Math.PI;

		
		#if FLX_DEBUG
		//Add debugging
		FlxG.console.registerObject("ball", this);
		FlxG.watch.add(this, 'trueVelocity', 'tv');
		FlxG.watch.add(this, 'totalDistance', 'distance');
		FlxG.watch.add(this, 'totalDegrees', 'totaldeg');
		#end
		
	}
	
	
	override public function update(elapsed:Float):Void {
		var fromPlanet:Vec2 = body.position.sub(GameObjects.planet.body.position);
		
		body.force.set(fromPlanet).muleq(-1).length = fromPlanet.mul(1.5, true).length;
		
		
		trueVelocity.x = orbitDegrees - _oldDegrees;
		//if it made a complete rotation and reset, we need to adjust the difference
		if (_oldDegrees > orbitDegrees) {
			if ((_oldDegrees - orbitDegrees) > 180) {
				trueVelocity.x += 360;
			} else {
				
			}
		}
		
		//trueVelocity.x *= elapsed;
		circumfrence = 2 * Vec2.distance(GameObjects.planet.body.position, body.position) * Math.PI;
		var curSpeed = (FlxMath.bound(trueVelocity.x, 0) / 360) * circumfrence;
		totalDistance += curSpeed;
		PlayerData.totalDistance = curSpeed;
		PlayerData.totalDegrees = totalDegrees;
		
		_oldDegrees = orbitDegrees;
		
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
		var a = body.position.sub(GameObjects.planet.body.position, true).rotate(90 * FlxAngle.TO_RAD).angle;
		if (a < 0) a += (Math.PI * 2);
		return a;

	}

	//Get angle in DEGREES around the planet
	function get_orbitDegrees():Float {
		return orbitAngle * FlxAngle.TO_DEG;
	}
	
	//Returns the angle in RADIANS of current velocity
	function get_velocityAngle():Float {
		return body.velocity.angle;
	}
	
	function get_totalDegrees():Float {
		return (totalDistance / circumfrence) * 360;
	}
	
}