/**
 * Created by lvdeluxe on 14-04-02.
 */
package deluxe.gesture.data {
import flash.geom.Point;
import flash.geom.Rectangle;

public class TriangleData implements IGeometryData{

	public static const UP:String = "up";
	public static const DOWN:String = "down";
	public static const LEFT:String = "left";
	public static const RIGHT:String = "right";

	private var _position:Point;
	private var _maxRadius:Number;
	private var _width:Number;
	private var _height:Number;
	private var _bounds:Rectangle;

	private var _orientation:String;

	public var verticeA:Point;
	public var verticeB:Point;
	public var verticeC:Point;

	public function TriangleData(pX:Number, pY:Number, pWidth:Number, pHeight:Number, pGeom:Vector.<String>) {
		_position = new Point(pX, pY);
		_width = pWidth;
		_height = pHeight;
		_bounds = new Rectangle(pX - (_width / 2),pY - (_height / 2),_width,_height);

		_maxRadius = Math.sqrt((((_width / 2) * (_width / 2)) + ((_height / 2) * (_height / 2))));

		setOrientation(pGeom);
	}

	private function setOrientation(pGeom:Vector.<String>):void{
		if(pGeom == GestureTypes.TRIANGLE_DOWN_CLOCKWISE || pGeom == GestureTypes.TRIANGLE_DOWN_COUNTER_CLOCKWISE){
			_orientation = DOWN;
			verticeA = new Point(_position.x - (_width / 2), _position.y - (_height / 2));
			verticeB = new Point(_position.x + (_width / 2), _position.y - (_height / 2));
			verticeC = new Point(_position.x, _position.y + (_height / 2));
		}else if(pGeom == GestureTypes.TRIANGLE_UP_CLOCKWISE || pGeom == GestureTypes.TRIANGLE_UP_COUNTER_CLOCKWISE){
			_orientation = UP;
			verticeA = new Point(_position.x - (_width / 2), _position.y + (_height / 2));
			verticeB = new Point(_position.x, _position.y - (_height / 2));
			verticeC = new Point(_position.x + (_width / 2), _position.y + (_height / 2));
		}else if(pGeom == GestureTypes.TRIANGLE_RIGHT_CLOCKWISE || pGeom == GestureTypes.TRIANGLE_RIGHT_COUNTER_CLOCKWISE){
			_orientation = RIGHT;
			verticeA = new Point(_position.x - (_width / 2), _position.y + (_height / 2));
			verticeB = new Point(_position.x - (_width / 2), _position.y - (_height / 2));
			verticeC = new Point(_position.x + (_width / 2), _position.y);
		}else if(pGeom == GestureTypes.TRIANGLE_LEFT_CLOCKWISE || pGeom == GestureTypes.TRIANGLE_LEFT_COUNTER_CLOCKWISE){
			_orientation = LEFT;
			verticeA = new Point(_position.x - (_width / 2), _position.y);
			verticeB = new Point(_position.x + (_width / 2), _position.y - (_height / 2));
			verticeC = new Point(_position.x + (_width / 2), _position.y + (_height / 2));
		}
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

	public function get orientation():String {
		return _orientation;
	}

	public function get bounds():Rectangle {
		return _bounds;
	}
}
}
