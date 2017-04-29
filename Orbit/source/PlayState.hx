package;

import helpers.DragThrowController;
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
import helpers.debug.CameraController;
import nape.callbacks.CbEvent;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.geom.Vec2;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Transform;
import phys.CbTypes;
import phys.GravityController;
import system.Cameras;
import ui.UIDisplay;

class PlayState extends FlxState {
	public var gravityController:GravityController;

	public var sky:FlxSprite;
	public var planet:Planet;
	public var ball:Baseball;

	public var clouds:FlxSpriteGroup;
	
	public var hud:UIDisplay;
	
	
	override public function create():Void {
		super.create();
		
		GameObjects.playState = this;
		
		//allow this state to run behind in the background
		this.persistentUpdate = true;
		
		//show splash
		this.openSubState(new MenuState());


		add(sky = GameObjects.sky = new FlxSprite(0, 0, "assets/images/sky.png"));
		sky.cameras = [Cameras.skyCam];

		add(clouds = new FlxSpriteGroup());
		clouds.cameras = [Cameras.planetCam];

		add(planet = GameObjects.planet = new Planet(FlxG.width >> 1, 1565));
		add(ball = GameObjects.ball = new Baseball(FlxG.width / 2, FlxG.height / 2));

		planet.cameras = ball.cameras = [Cameras.planetCam];

		Cameras.planetCam.follow(ball, FlxCameraFollowStyle.LOCKON, .5);
		
		
		gravityController = new GravityController();
		

		addContent();
		
		
		add(hud = new UIDisplay());

		gravityController.init();

		#if FLX_DEBUG
		add(new DragThrowController(FlxNapeSpace.space, null, false));
		add(new CameraController(Cameras.debugCam));
		
		planet.cameras = ball.cameras = clouds.cameras = [Cameras.planetCam, Cameras.debugCam];
		
		
		FlxG.watch.add(ball.body, "position", "ballxy");
		
		
		//show debug cam
		Cameras.toggleDebugView();
		
		//turn on nape debug
		FlxNapeSpace.drawDebug = true;
		
		//add transform to console
		FlxG.console.registerObject("transform", FlxNapeSpace.shapeDebug.transform);
		
		//track debug camera
		FlxG.debugger.track(Cameras.debugCam);
		
		
		#end
		
		
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
		
		if (FlxNapeSpace.drawDebug) {
			var _m:Matrix = new Matrix();
			
			_m.translate(-Cameras.debugCam.scroll.x, -Cameras.debugCam.scroll.y);
			_m.scale(Cameras.debugCam.totalScaleX, Cameras.debugCam.totalScaleY);
			
			
			var _m2:Matrix = new Matrix();
			_m2.translate(FlxG.mouse.screenX - _m.tx, FlxG.mouse.screenY - _m.ty);
			
			
			_m2.concat(_m);
			//_m2.translate(Cameras.debugCam.scroll.x, Cameras.debugCam.scroll.y);
			
			//var p:Point = _m.transformPoint(new Point(Cameras.debugCam.scroll.x + FlxG.mouse.screenX, Cameras.debugCam.scroll.y + FlxG.mouse.screenY));

			//Cameras.debugCam.trueMousePosition.set(_m.tx,_m.ty);
			
			//_m.copyFrom(FlxNapeSpace.shapeDebug.display.transform.matrix);
			//var t:Transform = FlxNapeSpace.shapeDebug.display.transform;
			
			//_m.rotate(Math.PI / 12);
			FlxNapeSpace.shapeDebug.transform.reset().setAs(_m.a, _m.b, _m.c, _m.d, _m.tx, _m.ty);
			FlxG.watch.add(FlxNapeSpace.shapeDebug, "transform");
		}
		
		
		//apply a constant force
		GameObjects.playState.gravityController.applyGravity();
		
		
		#if FLX_DEBUG
		if (FlxG.keys.justPressed.D) {
			Cameras.toggleDebugView();
		}
		#end

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
		FlxNapeSpace.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.ANY, CbTypes.ball, CbTypes.cloud.including(CbTypes.planet), function(cb:InteractionCallback) {
			var spr:FlxNapeSprite = cb.int2.userData.sprite;
			
			if (Std.is(spr, Cloud)) {
				spr.kill();
			}
			
			if (Std.is(spr, Planet)) {
				//FlxG.sound.play("bounce");
				GameObjects.ball.body.velocity.muleq(.8);
			}
			
			
		}));

	}
}
