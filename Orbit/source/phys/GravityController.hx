package phys;
import system.Settings;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSpace;
import game.GameObjects;
import nape.geom.Geom;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyList;
import nape.shape.Circle;

/**
 * ...
 * @author Jonathan Snyder
 */
class GravityController {
	
	var samplePoint:Body;
	var planetaryBodies:BodyList;
	var distance:Float;

	public function new() {
		
	}
	
	
	public function init() {
		samplePoint = new Body();
		samplePoint.shapes.add(new Circle(.001));
		
		
		planetaryBodies = new BodyList();
		planetaryBodies.add(GameObjects.planet.body);
		
		#if FLX_DEBUG
		
		
		//FlxG.watch.add(this, "distance", "distance");
		
		#end
	}
	
	// Apply a gravitational impulse to all bodies
	// pulling them to the closest point of a planetary body.
	//
	// Because this is a constantly applied impulse, whose value depends
	// only on the positions of the objects, we can set the 'sleepable'
	// of applyImpulse to be true and permit these bodies to still go to
	// sleep.
	//
	// Applying a 'sleepable' impulse to a sleeping Body has no effect
	// so we may as well simply iterate over the non-sleeping bodies.
	public function applyGravity() {
		var closestA = Vec2.get();
		var closestB = Vec2.get();
		
		
		for (b in FlxNapeSpace.space.liveBodies) {
			// Find closest points between bodies.
			samplePoint.position.set(b.position);
			distance = Geom.distanceBody(GameObjects.planet.body, samplePoint, closestA, closestB);
			
			
			//cut the gravity off way before threshhold
			if (distance < Settings.maxDistanceFromPlanet) {
				continue;
			}
			
			//Gravitational Force
			var force:Vec2 = closestA.sub(b.position, true);
			
			//true gravity sucks, use this instead
			force.length = b.mass * 250000 / (distance * distance);
			
			//apply impulse (force * deltaTime)
			b.applyImpulse(force.muleq(FlxG.maxElapsed * 3), null, true);
			
			
		}

		closestA.dispose();
		closestB.dispose();
	}
	
}