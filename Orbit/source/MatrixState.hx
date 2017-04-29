package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.util.FlxColor;

/**
 * ...
 * @author Jonathan Snyder
 */
class MatrixState extends FlxState {
	
	var fixed:MatrixSpr;
	var transformed:MatrixSpr;

	override public function create():Void {
		super.create();
		
		add(fixed = new MatrixSpr(10, 10));
		add(transformed = new MatrixSpr(150, 200));
		
		
	}
}


class MatrixSpr extends FlxSprite {
	public function new(?X:Float = 0, ?Y:Float = 0, ?Color:FlxColor) {
		super(X, Y);
		Color = Color != null ? Color : FlxColor.PINK;
		makeGraphic(400, 350, Color);
	}
}