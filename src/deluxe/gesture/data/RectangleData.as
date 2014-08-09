/**
 * Created by lvdeluxe on 14-04-06.
 */
package deluxe.gesture.data {
import flash.geom.Point;
import flash.geom.Rectangle;

public class RectangleData implements IGeometryData{

	private var _position:Point;
	private var _maxRadius:Number;
	private var _width:Number;
	private var _height:Number;
	private var _bounds:Rectangle;

	public function RectangleData(pRect:Rectangle) {
		_bounds = pRect;
		_position = new Point(pRect.x + (pRect.width / 2), pRect.y + (pRect.height / 2));
		_width = pRect.width;
		_height = pRect.height;
		_maxRadius = Math.sqrt((((_width / 2) * (_width / 2)) + ((_height / 2) * (_height / 2))));
	}

	public function updateTime(dt:Number):void{

	}

	public function get position():Point {
		return _position;
	}

	public function get maxRadius():Number {
		return _maxRadius;
	}

	public function get width():Number {
		return _width;
	}

	public function get height():Number {
		return _height;
	}

	public function get bounds():Rectangle {
		return _bounds;
	}
}
}
