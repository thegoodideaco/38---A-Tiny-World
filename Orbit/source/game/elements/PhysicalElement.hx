package game.elements;

import flixel.addons.nape.FlxNapeSpace;
import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import nape.callbacks.CbEvent;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.InteractionListener;
import nape.callbacks.InteractionType;
import nape.phys.BodyType;
import nape.shape.Shape;
import phys.CbTypes;

/**
 * ...
 * @author Jonathan Snyder
 */
class PhysicalElement extends FlxNapeSprite {

	public var cbType:CbType;
	public var onCollide:InteractionCallback -> Void;
	public var shape(default, null):Shape;
	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset, CreateRectangularBody:Bool = true, EnablePhysics:Bool = true, Kinematic:Bool = false, ?OnCollide:InteractionCallback -> Void) {
		super(X, Y, SimpleGraphic, CreateRectangularBody, EnablePhysics);
		body.userData.sprite = this;
		
		shape = body.shapes.at(0);
		shape.userData.sprite = this;
		onCollide = OnCollide;
		if (Kinematic) {
			this.body.space = null;
			this.body.type = BodyType.KINEMATIC;
			this.body.space = FlxNapeSpace.space;
			
		}
		shape.cbTypes.add(CbTypes.cloud);

		if (onCollide != null) {
			trace("adding listener");
			
			//var l:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.SENSOR, CbType.ANY_BODY, GameObjects.ball.cbType,  onCollide);
			//l.space = FlxNapeSpace.space;
			//FlxNapeSpace.space.listeners.add();
		}
	}
	
}