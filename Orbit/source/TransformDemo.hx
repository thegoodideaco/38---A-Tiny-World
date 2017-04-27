package;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxAngle;
import flixel.math.FlxMatrix;
import flixel.util.FlxColor;
import nape.geom.Vec2;


class TransformDemo extends FlxState {
	public var _parent:FlxSprite;
	public var squares:Array<Square>;

	override public function create():Void {
		super.create();
		//cameras = [Cameras.uiCam];

		add(_parent = new FlxSprite(100, 100).makeGraphic(120, 120, FlxColor.YELLOW));

		squares = [];
		for (i in 0...50) {
			var s:Square = new Square(FlxG.random.float(-600, 600), FlxG.random.float(-600, 600), FlxG.random.int(20, 60), FlxG.random.color(), _parent);
			squares.push(s);
			add(s);
		}


		_parent.angularVelocity = 10;
	}


	override public function add(Object:FlxBasic):FlxBasic {
		Object.cameras = cameras;
		return super.add(Object);
	}


	override public function update(elapsed:Float):Void {


		if (FlxG.mouse.pressedRight) {
			_parent.setPosition(FlxG.mouse.x, FlxG.mouse.y);
		}

		if (FlxG.mouse.wheel != 0) {
			_parent.scale.scale(FlxG.mouse.wheel < 0 ? 1 - .15 : 1.15);
		}

		super.update(elapsed);
	}

}


@:access(flixel.FlxSprite)
class Square extends FlxSprite {
	public var _parent:FlxSprite;
	public var _relativeMatrix:FlxMatrix;
	public var transformEnabled:Bool = true;

	public function new(?X:Float = 0, ?Y:Float = 0, Size:Int = 50, Color:FlxColor = FlxColor.GRAY, ?Parent:FlxSprite) {
		super(X, Y);
		_parent = Parent;
		makeGraphic(Size, Size, Color);
		_relativeMatrix = new FlxMatrix();
	}

	override function drawComplex(camera:FlxCamera):Void {
		_frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
		_matrix.translate(-origin.x, -origin.y);
		_matrix.scale(scale.x, scale.y);

		if (bakedRotationAngle <= 0) {
			updateTrig();

			if (angle != 0)
				_matrix.rotateWithTrig(_cosAngle, _sinAngle);
		}

		_point.add(origin.x, origin.y);
		_matrix.translate(_point.x, _point.y);

		if (isPixelPerfectRender(camera)) {
			_matrix.tx = Math.floor(_matrix.tx);
			_matrix.ty = Math.floor(_matrix.ty);
		}

		//concatenate (this is the only modication an FlxSprite needs)
		_relativeMatrix.copyFrom(_matrix);
		if (_parent != null && transformEnabled) {
			_relativeMatrix.concat(_parent._matrix);
		}


		camera.drawPixels(_frame, framePixels, _relativeMatrix, colorTransform, blend, antialiasing, shader);

	}

	override public function update(elapsed:Float):Void {
		if (FlxG.keys.justPressed.SPACE) {
			transformEnabled = !transformEnabled;
		}

		if (FlxG.keys.pressed.RIGHT) {
			var v:Vec2 = Vec2.get(5, 0);
			v.rotate(angle * FlxAngle.TO_RAD).addeq(Vec2.weak(x, y));
			setPosition(v.x, v.y);

			v.dispose();
		}
		if (FlxG.keys.pressed.LEFT) {
			var v:Vec2 = Vec2.get(-5, 0);
			v.rotate(angle * FlxAngle.TO_RAD).addeq(Vec2.weak(x, y));
			setPosition(v.x, v.y);

			v.dispose();
		}
		
		
		super.update(elapsed);
	}
	
	
}