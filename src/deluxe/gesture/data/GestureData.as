/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-26
 * Time: 22:33
 * To change this template use File | Settings | File Templates.
 */
package deluxe.gesture.data {
import flash.geom.Point;

public class GestureData {

	private var _moveType:String;
	private var _position:Point;

	public function GestureData(type:String, pos:Point) {
		_moveType = type;
		_position = pos;
	}

	public function get moveType():String {
		return _moveType;
	}

	public function get position():Point {
		return _position;
	}
}
}
