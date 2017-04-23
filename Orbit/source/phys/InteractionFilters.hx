package phys;
import nape.dynamics.InteractionFilter;

/**
 * ...
 * @author Jonathan Snyder
 */
class InteractionFilters {

	
	public static var attracted:InteractionFilter;
	
	public static function init():Void {
		attracted = new InteractionFilter();
		attracted.sensorGroup = 2;
	}
	
}