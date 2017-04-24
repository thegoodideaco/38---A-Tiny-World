package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.addons.nape.FlxNapeSpace;
import nape.geom.Vec2;
import openfl.display.Sprite;
import phys.CbTypes;
import phys.InteractionFilters;
import system.Cameras;
import system.Settings;

class Main extends Sprite {
	public function new() {
		super();
		
		/**
		 * HXCPP DEBUGGING
		 */
		#if (debug && cpp && USING_VS_DEBUGGER && !telemetry)
		new debugger.HaxeRemote(true, "localhost");
		#end

		
		/**
		 * INIT PROJECT
		 */
		FlxG.signals.preStateCreate.addOnce(function(s:FlxState) {
			FlxG.autoPause = false;
			Cameras.init();
			
			//Init Physics
			FlxNapeSpace.init();
			CbTypes.init();
			InteractionFilters.init();
			
			
			#if FLX_DEBUG
			initDebug();
			#end
			
		});
		
		
		/**
		 * ADD NEW GAME
		 */
		addChild(new FlxGame(0, 0, PlayState, 1, 60, 60, true, false));
	}


	#if FLX_DEBUG
	function initDebug():Void {
		FlxG.console.autoPause = false;
		FlxG.console.registerClass(Vec2);
		FlxG.console.registerClass(FlxNapeSpace);
		FlxG.console.registerClass(InteractionFilters);
		FlxG.console.registerClass(Cameras);
		FlxG.console.registerClass(Settings);
	}
	#end

}
