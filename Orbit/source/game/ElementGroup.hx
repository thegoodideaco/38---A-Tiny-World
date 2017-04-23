package game;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;

/**
 * ...
 * @author Jonathan Snyder
 */
class ElementGroup extends FlxSpriteGroup {

	public function new() {
		super();
	}
	
	
	override public function add(Sprite:FlxSprite):FlxSprite {
		
		Sprite.cameras = cameras;
		super.add(Sprite);
		
		return Sprite;
	}
	
}