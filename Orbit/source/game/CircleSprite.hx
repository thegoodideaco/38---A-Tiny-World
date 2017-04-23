package game;

import flixel.addons.nape.FlxNapeSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import nape.callbacks.CbType;
import nape.phys.BodyType;
import nape.shape.Circle;

/**
 * ...
 * @author Jonathan Snyder
 */
class CircleSprite extends FlxNapeSprite {
	public var circle:Circle;
	public var cbType:CbType;
	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset, Radius:Float = 15, ?bodyType:BodyType) {
		super(X, Y, SimpleGraphic, false, false);
		
		//cbType = new CbType();
		
		if (SimpleGraphic != null) {
			Radius = graphic.width / 2;
		}
		
		
		createCircularBody(Radius, bodyType);
		circle = body.shapes.at(0).castCircle;
		var d:Int = Std.int(Radius * 2);
		if (SimpleGraphic == null) {
			makeGraphic(d, d, FlxColor.TRANSPARENT);
			FlxSpriteUtil.drawCircle(this);
		}
		
		physicsEnabled = true;
		
		
		
	}
	
}