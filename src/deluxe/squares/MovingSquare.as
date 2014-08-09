/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-01
 * Time: 21:30
 * To change this template use File | Settings | File Templates.
 */
package deluxe.squares {
import deluxe.GameData;
import deluxe.GameData;
import deluxe.gesture.DrawTarget;

import flash.geom.Point;
import flash.utils.getTimer;

public class MovingSquare{

	public static const LEFT:String = "left";
	public static const RIGHT:String = "right";
	public static const UP:String = "up";
	public static const DOWN:String = "down";

	public var rotation:Number;
	private var _speed:Number = 0.3;
	public var startPlace:String;
	public var dx:Number;
	public var dy:Number;

	public var indexInCurrent:uint;

	public var hitWall:String = "";

	private var _initialSize:uint = 4 * GameData.RESOLUTION_FACTOR;
	public var size:uint;

	public var center:Point = new Point();

	public var caughtBy:DrawTarget;
	private var _sizeDividedBy2:Number;

	private var _maxSize:uint = 40 * GameData.RESOLUTION_FACTOR;

	public var scale:Number;

	//private var _startTweenTime:Number;
	private var _startTweenX:Number;
	private var _diffTweenX:Number;
	private var _startTweenY:Number;
	private var _diffTweenY:Number;

	public function MovingSquare() {
		//init();
	}

	public function init():void{
		_speed = Main.CURRENT_LEVEL.squaresSpeed;
		size = _initialSize;
		caughtBy = null;
		_sizeDividedBy2 = size / 2;
		scale = size * 0.25;

		var location:Number = Math.random();

		if(location < 0.25){
			startPlace = LEFT;
		}else if(location < 0.5){
			startPlace = RIGHT;
		}else if(location < 0.75){
			startPlace = UP;
		}else{
			startPlace = DOWN;
		}
		setPosition();
		setRotation();
		setMovingValues();
	}


	private function setPosition():void{
		var offset:uint = 10 * GameData.RESOLUTION_FACTOR;
		switch(startPlace){
			case LEFT:
				center.x = _sizeDividedBy2;
				center.y = (uint)(offset + Math.random() * (GameData.STAGE_HEIGHT - (2 * offset))) - _sizeDividedBy2;
				break;
			case RIGHT:
				center.x = GameData.STAGE_WIDTH - _sizeDividedBy2;
				center.y = (uint)(offset + Math.random() * (GameData.STAGE_HEIGHT - (2 * offset)) - _sizeDividedBy2);
				break;
			case UP:
				center.x = (uint)(offset + Math.random() * (GameData.STAGE_WIDTH - (2 * offset))) - _sizeDividedBy2;
				center.y = _sizeDividedBy2;
				break;
			case DOWN:
				center.x = (uint)(offset + Math.random() * (GameData.STAGE_WIDTH - (2 * offset))) - _sizeDividedBy2;
				center.y = GameData.STAGE_HEIGHT - _sizeDividedBy2;
				break;
		}
	}

	public function setRotation():void{
		switch(startPlace){
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

	public function setMovingValues():void{
		if(rotation > 360){
			rotation -= 360;
		}
		rotation -= 90;
		rotation *= Math.PI / 180;
		var cos:Number = Math.cos(rotation);
		var sin:Number = Math.sin(rotation);
		_sizeDividedBy2 = size / 2;
		scale = size * 0.25;
		dx = cos * _speed;
		dy = sin * _speed;
	}

	private function updateSize():void{
		if(size < _maxSize){
			size += 2 * GameData.RESOLUTION_FACTOR;
			_sizeDividedBy2 = size / 2;
			scale = size * 0.25;
		}
	}

	public function update(dt:Number):void{
		hitWall = "";
		center.x += dx * dt * GameData.RESOLUTION_FACTOR;
		center.y += dy * dt * GameData.RESOLUTION_FACTOR;

		if(center.x < _sizeDividedBy2){
			updateSize();
			center.x = _sizeDividedBy2;
			dx *= -1;
			hitWall = LEFT;
		}else if(center.x > GameData.STAGE_WIDTH - _sizeDividedBy2){
			updateSize();
			center.x = GameData.STAGE_WIDTH - _sizeDividedBy2;
			dx *= -1;
			hitWall = RIGHT;
		}else if(center.y < _sizeDividedBy2){
			updateSize();
			center.y = _sizeDividedBy2;
			dy *= -1;
			hitWall = UP;
		}else if(center.y > GameData.STAGE_HEIGHT - _sizeDividedBy2){
			updateSize();
			center.y = GameData.STAGE_HEIGHT - _sizeDividedBy2;
			dy *= -1;
			hitWall = DOWN;
		}
	}

	public function setStartTweenTime():void{
		_startTweenX = center.x;
		_diffTweenX = caughtBy.data.position.x - _startTweenX;
		_startTweenY = center.y;
		_diffTweenY = caughtBy.data.position.y - _startTweenY;
	}

	public function moveToCenter(dt:Number):void{
		center.x = _diffTweenX * caughtBy.data.easeTime + _startTweenX;
		center.y = _diffTweenY * caughtBy.data.easeTime + _startTweenY;
	}

	public function reverse():void {
		dx *= -1;
		dy *= -1;
	}

	public function toString():String{
		return  "x = " + center.x.toString() +
				"\n y = " + center.y.toString() +
				"\n startPlace = " + startPlace +
				"\n-------------------";
	}

}
}
