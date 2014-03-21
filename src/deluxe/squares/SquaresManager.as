/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-08
 * Time: 15:56
 * To change this template use File | Settings | File Templates.
 */
package deluxe.squares {
import deluxe.GameSignals;
import deluxe.b2dLite;
import deluxe.gesture.DrawTarget;
import deluxe.gesture.data.EllipseData;

import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.System;
import flash.utils.Timer;

import starling.core.Starling;
import starling.text.BitmapFont;
import starling.text.TextField;
import starling.utils.HAlign;
import starling.utils.VAlign;

public class SquaresManager {

	[Embed(source="/assets/Kubus-Bold.ttf", fontName="kubus", fontFamily="kubus", embedAsCFF= "false")]
	private var FontClass:Class;
	private var _timer:Timer;
	private var _caughtMovingObjects:Vector.<MovingSquare> = new Vector.<MovingSquare>();
	private var _movingObjects:Vector.<MovingSquare> = new Vector.<MovingSquare>();
	private var _toDie:int = 0;

	private var _checkForEllipse:Boolean = false;

	private var _verticeA:Point = new Point();
	private var _verticeB:Point = new Point();
	private var _verticeC:Point = new Point();
	private var _verticeD:Point = new Point();

	private var _totalPixels:uint = 1136 * 640;
	private var _currentPixels:uint = 0;

	private var _ellipses:Vector.<EllipseData> = new Vector.<EllipseData>();

//	private var _renderer:ISquareRenderer;

	private var _maxSquares:uint = 5000;

	private var _tf:TextField;

//	private var _tFormat:TextFormat;

	private var _renderer:b2dLite;

	private var _pool:Vector.<MovingSquare> = new Vector.<MovingSquare>();
	private var _numSquares:uint = 0;

	public function SquaresManager(renderer:b2dLite) {
		GameSignals.ELLIPSE_DRAW.add(onEllipseDrawn);
		GameSignals.ELLIPSE_EXPLODE.add(onEllipseExplode);
		GameSignals.ELLIPSE_CANCEL.add(onEllipseCancel);

		_renderer = renderer;

		createSquares();

		_timer = new Timer(500,0);
		_timer.addEventListener(TimerEvent.TIMER, onTimer);
		_timer.start();
		onTimer(null);
//		_renderer = new BitmapSquaresRenderer(pStage);

		_tf = new TextField(800, 100, BitmapFont.MINI, "Verdana", 36, 0xffffff);
		_tf.x = 336;
//		_tf.y = 10;
		_tf.vAlign = VAlign.TOP;
		_tf.hAlign = HAlign.RIGHT;
//		_tf.scaleX = 10;
//		_tf.scaleY = 10;
		Starling.current.stage.addChild(_tf);
	}

	private function createSquares():void {
		for(var i:uint = 0 ; i < _maxSquares ; i++){
			_pool.push(new MovingSquare());
		}
	}

	private function onEllipseExplode(drawTarget:DrawTarget):void{
		_ellipses.splice(_ellipses.indexOf(drawTarget.data), 1);
		_checkForEllipse = _ellipses.length != 0;
		var toDestroy:Vector.<uint> = new Vector.<uint>();
		for(var i:int = 0 ; i < _caughtMovingObjects.length ; i++){
			if(_caughtMovingObjects[i].caughtBy == drawTarget){
				var index:uint = _movingObjects.indexOf(_caughtMovingObjects[i]);
				toDestroy.push(index);
			}
		}
		for(i = toDestroy.length - 1 ; i >= 0; i--){
			var mo:MovingSquare = _movingObjects.splice(toDestroy[i],1)[0];
			_currentPixels -= (mo.size * mo.size);
			mo = null;
		}
		System.gc();
	}

	private function onEllipseCancel(drawTarget:DrawTarget):void{
		_ellipses.splice(_ellipses.indexOf(drawTarget.data),1);
		_checkForEllipse = _ellipses.length != 0;
		for(var i:int = _caughtMovingObjects.length - 1 ; i >= 0 ; i--){
			if(_caughtMovingObjects[i].caughtBy == drawTarget){
				_caughtMovingObjects[i].caughtBy = null;
				_caughtMovingObjects.splice(i,1);
			}
		}
	}

	private function onEllipseDrawn(drawTarget:DrawTarget):void{
		if(drawTarget!= null){
			_checkForEllipse = true;
			_ellipses.push(drawTarget.data);
			catchAllMovingObjects(drawTarget);
		}
	}

	private function catchAllMovingObjects(drawTarget:DrawTarget):void{
		for(var i:uint = 0 ; i < _movingObjects.length ; i++){
			var mo:MovingSquare = _movingObjects[i] as MovingSquare;
			var intersects:uint = checkEllipseIntersectionsWithPoint(mo.center);
			if(intersects == 4){
				_caughtMovingObjects.push(mo);
				mo.caughtBy = drawTarget;
			}
		}
	}

	private function onTimer(event:TimerEvent):void {
		createMovingObject()
	}

	private function createMovingObject(clone:MovingSquare = null):void {
		if(_numSquares == _maxSquares - 1)
			return;
		_numSquares++;
		if(clone){
			_pool[_numSquares].size = clone.size;
			_pool[_numSquares].x = clone.x;
			_pool[_numSquares].y = clone.y;
			_pool[_numSquares].startPlace = clone.hitWall;
			_pool[_numSquares].setRotation();
			_pool[_numSquares].setMovingValues();
		}
//		var newOne:MovingSquare = new MovingSquare();
//		_movingObjects.push(newOne);
		_currentPixels += _pool[_numSquares].size *  _pool[_numSquares].size;
//		if(_movingObjects.length > 500){
//			_toDie++;
//		}else{
//			_toDie = 0;
//		}
	}

	private function checkEllipseIntersectionsWithPoint(center:Point):int{
		if(!_checkForEllipse)
			return 0;
		else{
			for(var i:uint = 0 ; i < _ellipses.length ; i++){
				var ellipse:EllipseData = _ellipses[i];
				var returnVal:uint = 0;
				if(ellipse.bounds.containsPoint(center)){
					_verticeA.x = center.x - ellipse.center.x;
					_verticeA.y = center.y - ellipse.center.y;
					if(((_verticeA.x * _verticeA.x) * ellipse.squaredXRadius) + ((_verticeA.y * _verticeA.y) * ellipse.squaredYRadius) <= 1.0)
						returnVal = 4;
				}
			}
			return returnVal;
		}
	}
	private function checkEllipseIntersections(rect:Rectangle):int{
		if(!_checkForEllipse)
			return 0;
		else{
			for(var i:uint = 0 ; i < _ellipses.length ; i++){
				var ellipse:EllipseData = _ellipses[i];
				var returnVal:uint = 0;
				if(ellipse){
					if(ellipse.bounds.containsRect(rect)){
						_verticeA.x = rect.x - ellipse.center.x;
						_verticeA.y = rect.y - ellipse.center.y;
						_verticeB.x = rect.x + rect.width - ellipse.center.x;
						_verticeB.y = rect.y - ellipse.center.y;
						_verticeC.x = rect.x + rect.width - ellipse.center.x;
						_verticeC.y = rect.y + rect.height - ellipse.center.y;
						_verticeD.x = rect.x - ellipse.center.x;
						_verticeD.y = rect.y + rect.height - ellipse.center.y;
						if(((_verticeA.x * _verticeA.x) / ellipse.squaredXRadius) + ((_verticeA.y * _verticeA.y) / ellipse.squaredYRadius) <= 1.0)
							returnVal++;
						if(((_verticeB.x * _verticeB.x) / ellipse.squaredXRadius) + ((_verticeB.y * _verticeB.y) / ellipse.squaredYRadius) <= 1.0)
							returnVal++;
						if(((_verticeC.x * _verticeC.x) / ellipse.squaredXRadius) + ((_verticeC.y * _verticeC.y) / ellipse.squaredYRadius) <= 1.0)
							returnVal++;
						if(((_verticeD.x * _verticeD.x) / ellipse.squaredXRadius) + ((_verticeD.y * _verticeD.y) / ellipse.squaredYRadius) <= 1.0)
							returnVal++;
					}
				}
			}
			return returnVal;
		}
	}

	public function update():void{
//		_renderer.clear();

		var toDie:int = _toDie;
		if(toDie < 0){
			toDie = 0;
		}
//		_renderer.prepare();

//		var len:uint = _movingObjects.length - 1;
//		trace(len)
		for(var i:int = 0 ; i < _numSquares; i++){
			var mo:MovingSquare = _pool[i] as MovingSquare;
//			if(i < toDie){
//				mo.mustDie = true;
//			}
//			if(!mo.isDead){
			if(mo.caughtBy == null){
				var intersects:uint = checkEllipseIntersectionsWithPoint(mo.center);//mo.size > 4 ? checkEllipseIntersectionsWithPoint(mo.center) : checkEllipseIntersectionsWithPoint(mo.center);
				if(intersects == 0){
					mo.update();
					if(mo.hitWall != ""){
						_currentPixels += ((mo.size * mo.size) - ((mo.size - 2) * (mo.size - 2)));
						createMovingObject(mo);
					}
				}else{
					mo.reverse();
					mo.update();
				}
			}else{
				mo.moveToCenter();
			}
			_renderer.renderQuad(mo.size, mo.size, mo.x, mo.y);
//			_renderer.draw(mo.fillRectangle);
//			}
//			else{
//				_movingObjects.splice(i,1);
//				_currentPixels -= (mo.size * mo.size);
//				mo = null;
//				_toDie--;
//			}
		}
//		_renderer.release();
		var prct:Number = uint(_currentPixels / _totalPixels * 100)
		_tf.text = prct.toString() + "% / " + _numSquares.toString() + " quads";
//		_tFormat = new TextFormat();
//		_tFormat.font = "kubus";
//		_tFormat.size = 64;
//		_tf.setTextFormat(_tFormat);
	}
}
}
