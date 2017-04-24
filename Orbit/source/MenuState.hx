package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.ui.FlxButton;
import game.GameObjects;

class MenuState extends FlxSubState {
	
	
	var bg:FlxSprite;
	var btn:FlxButton;
	
	override public function create():Void {
		super.create();
		
		add(bg = new FlxSprite(0, 0, "assets/images/splash.png"));
	}

	override public function update(elapsed:Float):Void {
		
		if (FlxG.mouse.justReleased) {
			
			GameObjects.playState.startGame();
			GameObjects.playState.closeSubState();
		}
		
		super.update(elapsed);
	}
}
