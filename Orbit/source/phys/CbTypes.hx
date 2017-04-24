package phys;
import nape.callbacks.CbType;

/**
 * ...
 * @author Jonathan Snyder
 */
class CbTypes {

	
	public static var ball:CbType;
	public static var cloud:CbType;
	public static var planet:CbType;
	
	public static function init():Void {
		ball = new CbType();
		cloud = new CbType();
		planet = new CbType();
	}
}