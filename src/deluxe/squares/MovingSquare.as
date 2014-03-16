/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-01
 * Time: 21:30
 * To change this template use File | Settings | File Templates.
 */
package deluxe.squares {
import deluxe.gesture.DrawTarget;

import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

public class MovingSquare{

	public static const LEFT:String = "left";
	public static const RIGHT:String = "right";
	public static const UP:String = "up";
	public static const DOWN:String = "down";

	public static const COLORS:Array = [0xffcc0000, 0xff00cc00, 0xff0000cc];

	public var rotation:Number;
	private var _speed:Number = 4;
	private var _startPlace:String;
	public var dx:Number;
	public var dy:Number;

	public var hitWall:String = "";

	public var color:uint;
	public var size:uint = 4;
	public var mustDie:Boolean = false;
	public var isDead:Boolean = false;

	public var x:Number;
	public var y:Number;

	public var fillRectangle:Rectangle;
	public var nextFillRectangle:Rectangle;
	public var center:Point = new Point();

	public var caughtBy:DrawTarget;

	private var _maxSize:uint = 40;

	public function MovingSquare(clone:MovingSquare) {
		fillRectangle = new Rectangle();
		nextFillRectangle = new Rectangle();
		if(clone){
			color = clone.color;
			size = clone.size;
			x = clone.x;
			y = clone.y;
			_startPlace = clone.hitWall;
			setRotation();
		}else{
			color = Math.random() * 0xffffffff;//0x40ffffff;//COLORS[Math.floor(Math.random() * COLORS.length)];

			var location:Number = Math.random();

			if(location < 0.25){
				_startPlace = LEFT;
			}else if(location < 0.5){
				_startPlace = RIGHT;
			}else if(location < 0.75){
				_startPlace = UP;
			}else{
				_startPlace = DOWN;
			}
			setPosition();
			setRotation();

		}
		setMovingValues(rotation);
	}

	private function setPosition():void{
		switch(_startPlace){
			case LEFT:
				x = (size / 2);
				y = (uint)(10 + Math.random() * 620) - (size / 2);
				break;
			case RIGHT:
				x = 1136 - (size / 2);
				y = (uint)(10 + Math.random() * 620 - (size / 2));
				break;
			case UP:
				x = (uint)(10 + Math.random() * 1126) - (size / 2);
				y = (size / 2);
				break;
			case DOWN:
				x = (uint)(10 + Math.random() * 1116) - (size / 2);
				y = 640 - (size / 2);
				break;
		}
	}

	private function setRotation():void{
		switch(_startPlace){
			case LEFT:
				rotation = 45 + (Math.random() * 90);
				if(rotation > 70 && rotation < 110){
					if(rotation > 70){
						rotation = 70;
					}
					if(rotation < 110){
						rotation = 110;
					}
				}
				break;
			case RIGHT:
				rotation = 225 + (Math.random() * 90);
				if(rotation > 250 && rotation < 290){
					if(rotation > 250){
						rotation = 250;
					}
					if(rotation < 290){
						rotation = 290;
					}
				}
				break;
			case UP:
				rotation = 135 + (Math.random() * 90);
				if(rotation > 160 && rotation < 200){
					if(rotation > 160){
						rotation = 160;
					}
					if(rotation < 200){
						rotation = 200;
					}
				}
				break;
			case DOWN:
				rotation = 315 + (Math.random() * 90);
				if(rotation > 340 && rotation < 380){
					if(rotation > 340){
						rotation = 340;
					}
					if(rotation < 380){
						rotation = 380;
					}
				}
				break;
		}
	}

	public function setMovingValues(rot:Number):void{
		if(rot > 360){
			rot -= 360;
		}
		rot -= 90;
		rot *= Math.PI / 180;
		var cos:Number = Math.cos(rot);
		var sin:Number = Math.sin(rot);
		dx = cos * _speed;
		dy = sin * _speed;
		_speed *= Math.random() * 2;
	}

	public function moveToCenter():void{

	}

	public function update():void{
		hitWall = "";
		x += dx;
		y += dy;
		if(x < (size / 2)){
			x = (size / 2);
			dx *= -1;
			hitWall = LEFT;
		}else if(x > 1136 - (size / 2)){
			x = 1136 - (size / 2);
			dx *= -1;
			hitWall = RIGHT;
		}
		if(y < (size / 2)){
			y = (size / 2);
			dy *= -1;
			hitWall = UP;
		}else if(y > 640 - (size / 2)){
			y = 640 - (size / 2);
			dy *= -1;
			hitWall = DOWN;
		}
		if(hitWall){
			if(mustDie){
				isDead = true;
			}else{
				if(size < _maxSize)
					size += 2;
			}
		}

		nextFillRectangle.x = int(x + dx - (size / 2));
		nextFillRectangle.y = int(y + dy - (size / 2));
		nextFillRectangle.width = size;
		nextFillRectangle.height = size;

		fillRectangle.x = int(x - (size / 2));
		fillRectangle.y = int(y - (size / 2));
		fillRectangle.width = size;
		fillRectangle.height = size;
		center.x = x;
		center.y = y;
	}

	public function reverse():void {
		dx *= -1;
		dy *= -1;
	}
}
}
