package;

import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxAngle;
import game.Baseball;
import game.GameObjects;
import game.Planet;
import game.elements.Cloud;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;
import phys.CbTypes;
import system.Cameras;

class PlayState extends FlxState {

	public var sky:FlxSprite;
	public var planet:Planet;
	public var ball:Baseball;

	public var clouds:FlxSpriteGroup;

	override public function create():Void {
		super.create();
		
		
		
		

		add(sky = new FlxSprite(0, 0, "assets/images/sky.png"));
		sky.cameras = [Cameras.skyCam];

		add(clouds = new FlxSpriteGroup());
		clouds.cameras = [Cameras.planetCam];

		add(planet = new Planet(FlxG.width >> 1, 1565));
		add(ball = new Baseball(FlxG.width / 2, FlxG.height / 2));

		planet.cameras = ball.cameras = [Cameras.planetCam];

		Cameras.planetCam.follow(ball, FlxCameraFollowStyle.LOCKON, .5);

		GameObjects.sky = sky;
		GameObjects.ball = ball;
		GameObjects.planet = planet;

		addContent();
	}

	function addContent() {
		//var cloud:Cloud = new FlxSprite(0, 0, "assets/images/cloud1.png");
		//cloud.cameras = clouds.cameras;

		for (i in 0...50) {
			var c = new Cloud(0, 0);
			c.scale.set(1, 1).scale(FlxG.random.float(.3, 1.3));
			c.updateHitbox();
			c.body.scaleShapes(c.scale.x, c.scale.y);

			addGameSprite(c, clouds, FlxG.random.float(100, 800), FlxG.random.float(0, 360));
		}

	}

	override public function update(elapsed:Float):Void {

		Cameras.planetCam.angle = 90 - (ball.body.position.sub(planet.body.position, true).muleq(-1).angle * FlxAngle.TO_DEG);
		super.update(elapsed);
	}

	public function addGameSprite(object:FlxNapeSprite, ?objectContainer:FlxSpriteGroup, distance:Float, degrees:Float):FlxSprite {

		//first add the object
		if (objectContainer != null) {
			objectContainer.add(object);
		}
		else {
			add(object);
		}

		//assign position
		var pos:Vec2 = Vec2.get(planet.radius + distance + (object.height / 2), 0);

		//rotate vec to angle
		pos.angle = (degrees - 90) * FlxAngle.TO_RAD;

		//set relative to planet position
		pos.addeq(planet.body.position);

		//set position to object
		object.body.position.set(pos);

		//release to vec pool
		pos.dispose();

		//rotate the object
		object.body.rotation = degrees * FlxAngle.TO_RAD;

		//set cameras
		object.cameras = [Cameras.planetCam];

		return object;
	}
	
	
	public function startGame():Void {
				FlxNapeSpace.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, CbTypes.ball, CbTypes.cloud.including(CbTypes.planet), function(cb:InteractionCallback){
			var spr:FlxNapeSprite = cb.int2.userData.sprite;
			
			if (Std.is(spr, Cloud)){
				spr.kill();
			}
			
			if (Std.is(spr, Planet)){
				FlxG.sound.play("bounce");
				GameObjects.ball.body.velocity.muleq(.8);
			}
			
			
			//trace(Std.is(cb.int2.userData.sprite, Cloud));
			//cloud.kill();
			
			
		}));

	}
}
