/**
 * Created by lvdeluxe on 14-04-03.
 */
package deluxe.gesture.data {
import flash.geom.Point;
import flash.geom.Rectangle;

public interface IGeometryData {

	function get width():Number;
	function get height():Number;
	function get position():Point;
	function get maxRadius():Number;
	function get bounds():Rectangle;
	function updateTime(dt:Number):void;
}
}
