/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-02
 * Time: 14:23
 * To change this template use File | Settings | File Templates.
 */
package deluxe.gesture.data {
import flash.geom.Point;
import flash.geom.Rectangle;

public class EllipseData {

	private var _position:Point;
	private var _center:Point;
	private var _bounds:Rectangle;
	private var _squaredXRadius:Number;
	private var _squaredYRadius:Number;

	public function EllipseData(xRad:Number, yRad:Number, posX:Number, posY:Number) {
		_position = new Point(posX, posY);
		_center = new Point(posX + xRad, posY + yRad);
		_bounds = new Rectangle(posX, posY, xRad * 2, yRad * 2);
		_squaredXRadius = 1 / (xRad * xRad);
		_squaredYRadius = 1 / (yRad * yRad);
	}

	public function get position():Point {
		return _position;
	}

	public function get center():Point {
		return _center;
	}

	public function get bounds():Rectangle {
		return _bounds;
	}

	public function get squaredXRadius():Number {
		return _squaredXRadius;
	}

	public function get squaredYRadius():Number {
		return _squaredYRadius;
	}
}
}
