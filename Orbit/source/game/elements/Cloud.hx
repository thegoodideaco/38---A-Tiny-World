package game.elements;

import nape.callbacks.CbType;
import nape.phys.Body;
import flixel.FlxG;
import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.callbacks.InteractionCallback;
import nape.phys.BodyType;
import phys.CbTypes;

/**
 * ...
 * @author Jonathan Snyder
 */
class Cloud extends PhysicalElement {

	public function new(X:Float = 0, Y:Float = 0) {
		
		super(X, Y, "assets/images/cloud1.png", true, true, true);

		shape.sensorEnabled = true;
		//shape.cbTypes.add(CbTypes.cloud);
	}
	
	
	override public function kill():Void {
		#if !flash
		FlxG.sound.play("bounce");
		#end
		
		//apply an impulse to the ball;
		//GameObjects.ball.body.velocity.setxy(0, 0);
		GameObjects.ball.bounce();
		GameObjects.ball.hurt(.5);
		
		//trace("testing");
		
		super.kill();
		
	}
}