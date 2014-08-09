/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-02
 * Time: 14:23
 * To change this template use File | Settings | File Templates.
 */
package deluxe.gesture.data {
import deluxe.GameData;

import flash.geom.Point;
import flash.geom.Rectangle;

public class EllipseData implements IGeometryData{

	private var _position:Point;
	private var _bounds:Rectangle;
	private var _xRadius:Number;
	private var _yRadius:Number;
	private var _squaredXRadius:Number;
	private var _squaredYRadius:Number;
	private var _maxRadius:Number;
	public var easeTime:Number;
	private var _startTime:Number = 0;
	public var explosionTime:Number;

	public function EllipseData(xRad:Number, yRad:Number, posX:Number, posY:Number) {
		_position = new Point(posX + xRad, posY + yRad);
		_bounds = new Rectangle(posX, posY, xRad * 2, yRad * 2);
		_xRadius = xRad;
		_yRadius = yRad;
		_squaredXRadius = 1 / (xRad * xRad);
		_squaredYRadius = 1 / (yRad * yRad);
		_maxRadius = _xRadius > _yRadius ? _xRadius : _yRadius;
	}

	public function updateTime(dt:Number):void{
		var ref:Number = _startTime;
		easeTime = (ref /= explosionTime)* ref * ((GameData.EASE_FACTOR + 1) * ref - GameData.EASE_FACTOR);
		_startTime += dt * 0.001;
	}

	public function get position():Point {
		return _position;
	}

	public function get bounds():Rectangle {
		return _bounds;
	}

	public function get maxRadius():Number {
		return _maxRadius;
	}

	public function get squaredXRadius():Number {
		return _squaredXRadius;
	}

	public function get squaredYRadius():Number {
		return _squaredYRadius;
	}

	public function get width():Number {
		return _xRadius * 2;
	}

	public function get height():Number {
		return _yRadius * 2;
	}
}
}
