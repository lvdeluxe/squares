/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-08
 * Time: 15:56
 * To change this template use File | Settings | File Templates.
 */
package deluxe.squares {

import com.genome2d.Genome2D;
import com.genome2d.context.GBlendMode;
import com.genome2d.context.IContext;
import com.genome2d.textures.GTexture;
import com.genome2d.textures.GTextureFilteringType;
import com.genome2d.textures.factories.GTextureFactory;
import com.greensock.TweenLite;
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Circ;

import deluxe.AssetsManager;
import deluxe.ExtendedTimer;
import deluxe.GameData;
import deluxe.GameSignals;
import deluxe.gesture.DrawTarget;
import deluxe.gesture.data.EllipseData;
import deluxe.gesture.data.IGeometryData;
import deluxe.gesture.data.RectangleData;
import deluxe.gesture.data.TriangleData;
import deluxe.ui.GameHUD;

import flash.display.BitmapData;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

public class SquaresManager {


	private var _timer:ExtendedTimer;

	private var _checkForGesture:Boolean = false;

	private var _contact:Point = new Point();

//	private var _totalPixels:uint = 1136 * 640;
	private var _currentPixels:uint = 0;

	private var _geometries:Vector.<IGeometryData> = new Vector.<IGeometryData>();

	private var _maxSquares:uint = 5000;

//	private var _textureDefault:GTexture;
//	private var _textureCaught:GTexture;

	private var _context:IContext;

	private var _gameOver:Boolean = false;

	private var _pool:Vector.<MovingSquare> = new Vector.<MovingSquare>();
	private var _current:Vector.<MovingSquare> = new Vector.<MovingSquare>();
	private var _genome2d:Genome2D = Genome2D.getInstance();

	private var _hud:GameHUD;

	private var _paused:Boolean = false;

	private var _planeAB:Number;
	private var _planeBC:Number;
	private var _planeCA:Number;

	private var _currentScore:ScoreData;

	private var _isTutorial:Boolean = false;
	private var _incSpawnTutorial:Number = 0;
	private var _isTutorialStep2:Boolean = false;

	public function SquaresManager(pHud:GameHUD) {
		_hud = pHud;
		GameSignals.GESTURE_DRAW.add(onGestureDrawn);
		GameSignals.ELLIPSE_EXPLODE.add(onEllipseExplode);
		GameSignals.ELLIPSE_CANCEL.add(onEllipseCancel);
		GameSignals.TUT_STEP_1_START.add(onTutStep1);
		GameSignals.TUT_STEP_1_COMPLETE.add(onTutStep1Complete);
		GameSignals.TUT_STEP_3_COMPLETE.add(onTutStep2Complete);

		_context = _genome2d.getContext();
		createSquares();
	}

	private function onTutStep2Complete():void{
		_isTutorialStep2 = false;
	}
	private function onTutStep1Complete():void{
		_isTutorial = false;
		_isTutorialStep2 = true;
	}
	private function onTutStep1(pos:Point):void{
		_isTutorial = true;
	}

	public function startLevel():void{
		_hud.updateNumSquares(0);
		_hud.updatePercent(0);
		_hud.updateTime(0);
		for(var i:uint = 0 ; i < _pool.length ; i++){
			_pool[i].init();
		}
		_gameOver = false;
		_paused = false;
		_currentScore = new ScoreData();
		_timer = new ExtendedTimer(Main.CURRENT_LEVEL.tickSpeed,0);
		_timer.addEventListener(TimerEvent.TIMER, onTimer);
		_timer.start();
		for(var j:uint = 0 ; j < Main.CURRENT_LEVEL.numSquaresSpawned ; j++)
			createMovingObject();
	}

	public function setGameOverState():void{
		if(_timer){
			_timer.stop();
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
		}
	}

	public function cleanup():void{
		for(var i:uint = 0 ; i < _current.length; i++){
			_pool.push(_current[i]);
		}
		_current = new Vector.<MovingSquare>();
		_geometries = new Vector.<IGeometryData>();
	}

	public function pause():void{
		_paused = true;
		_timer.pause();
	}
	public function resume():void{
		_paused = false;
		_timer.resume();
	}

	private function createSquares():void {
		for(var i:uint = 0 ; i < _maxSquares ; i++){
			_pool.push(new MovingSquare());
		}
	}

	private function onEllipseExplode(drawTarget:DrawTarget):void{
		_geometries.splice(_geometries.indexOf(drawTarget.data), 1);
		_checkForGesture = _geometries.length != 0;
		var i:int;
		var mo:MovingSquare;
		var len:int = _current.length - 1;
		var destroyedInGesture:uint = _currentScore.destroyed;
		for(i = len ; i >= 0 ; --i){
			mo = _current[i];
			if(mo.caughtBy == drawTarget){
				_currentPixels -= (mo.size * mo.size);
				mo.init();
				_pool.push(_current.splice(i, 1)[0]);
				_currentScore.destroyed++;
			}
		}
		var diff:uint = _currentScore.destroyed - destroyedInGesture;
		if(diff > 0){
			if(drawTarget.data is EllipseData)
				_currentScore.numEllipses++;
			if(drawTarget.data is TriangleData)
				_currentScore.numTriangles++;
			if(drawTarget.data is RectangleData)
				_currentScore.numRectangles++;
		}
		_currentScore.maxInOneGesture = Math.max(_currentScore.maxInOneGesture, diff);
		if(_currentScore.destroyed >= Main.CURRENT_LEVEL.numSquaresToCatch){
			_gameOver = true;
			_timer.stop();
			TweenMax.killAll();
			GameSignals.GAME_OVER.dispatch(true, _currentScore);
		}
		_hud.updateNumSquares(_currentScore.destroyed);
		if(_geometries.length <= 1)
			_currentScore.setCombo(_geometries.length);
	}

	private function onEllipseCancel(drawTarget:DrawTarget):void{
		_geometries.splice(_geometries.indexOf(drawTarget.data),1);
		_checkForGesture = _geometries.length != 0;
		for(var i:int = _current.length - 1 ; i >= 0 ; i--){
			if(_current[i].caughtBy == drawTarget){
				_current[i].caughtBy = null;
			}
		}
		if(_geometries.length <= 1)
			_currentScore.setCombo(_geometries.length);
	}

	private function onGestureDrawn(drawTarget:DrawTarget):void{
		if(drawTarget!= null){
			var ratio:Number = drawTarget.data.width / drawTarget.data.height;
			if(ratio > 0.95 && ratio < 1.05){
				GameSignals.PERFECT_CIRCLE.dispatch();
				_currentScore.perfectCircles++;
			}
			_currentScore.numGesturesTotal++;
			_checkForGesture = true;
			_geometries.push(drawTarget.data);
			catchAllMovingObjects(drawTarget);
			_currentScore.numGesturesOnce = Math.max(_currentScore.numGesturesOnce, _geometries.length);
			_currentScore.setCombo(_geometries.length);

		}
	}

	private function catchAllMovingObjects(drawTarget:DrawTarget):void{
		for(var i:uint = 0 ; i < _current.length ; i++){
			var mo:MovingSquare = _current[i] as MovingSquare;
			if(mo.caughtBy == null){
				var intersects:Boolean = checkIntersectionsWithPoint(mo.center);
				if(intersects){
					mo.caughtBy = drawTarget;
					TweenMax.to(mo.center,Main.CURRENT_LEVEL.gestureExplosionSpeedMilli,{x:drawTarget.data.position.x, y:drawTarget.data.position.y, ease:Back.easeIn});
				}
			}
		}
	}

	private function onTimer(event:TimerEvent):void {
		if(_isTutorialStep2){
			if(_incSpawnTutorial == 5)
				return;
			else
				_incSpawnTutorial++;
		}
		for(var i:uint = 0 ; i < Main.CURRENT_LEVEL.numSquaresSpawned ; i++)
			createMovingObject();
	}

	private function createMovingObject(clone:MovingSquare = null):void {
		if(_pool.length == 0)
			return;

		var pooled:MovingSquare = _pool.pop();

		if(clone){
			//pooled.size = clone.size;
			pooled.center.x = clone.center.x;
			pooled.center.y = clone.center.y;
			pooled.startPlace = clone.hitWall;
			pooled.setRotation();
			pooled.setMovingValues();
		}
		pooled.indexInCurrent = _current.length;
		_current.push(pooled);
		_currentPixels += pooled.size *  pooled.size;
	}

	private function checkIntersectionsWithPoint(center:Point):Boolean{
		if(!_checkForGesture)
			return 0;
		else{
			var returnVals:Array = [];
			for(var i:uint = 0 ; i < _geometries.length ; i++){
				var geometry:IGeometryData = _geometries[i];
				if(geometry is EllipseData){
					returnVals.push(testEllipseIntersection(geometry as EllipseData, center));
				}else if(geometry is TriangleData){
					returnVals.push(testTriangleIntersection(geometry as TriangleData, center));
				}else if (geometry is RectangleData){
					returnVals.push(testRectangleIntersection(geometry as RectangleData, center));
				}
			}
			return returnVals.indexOf(true) != -1;
		}
	}

	private function testRectangleIntersection(rect:RectangleData, pt:Point):Boolean{
//		if(Point.distance(pt, rect.position) <= rect.maxRadius){
			return rect.bounds.containsPoint(pt);
//		}
//		return false;
	}

	private function testTriangleIntersection(triangle:TriangleData, pt:Point):Boolean{
//		if(Point.distance(pt, triangle.position) <= triangle.maxRadius){
//			if(triangle.bounds.containsPoint(pt)){

				_planeAB = (triangle.verticeA.x-pt.x)*(triangle.verticeB.y-pt.y)-(triangle.verticeB.x - pt.x)*(triangle.verticeA.y-pt.y);
				_planeBC = (triangle.verticeB.x-pt.x)*(triangle.verticeC.y-pt.y)-(triangle.verticeC.x - pt.x)*(triangle.verticeB.y-pt.y);
				_planeCA = (triangle.verticeC.x-pt.x)*(triangle.verticeA.y-pt.y)-(triangle.verticeA.x - pt.x)*(triangle.verticeC.y-pt.y);

				return Math.abs(_planeAB)/_planeAB == Math.abs(_planeBC) / _planeBC && Math.abs(_planeBC) / _planeBC == Math.abs(_planeCA) / _planeCA;
//			}
//		}
//		return false;
	}

	private function testEllipseIntersection(ellipse:EllipseData, pt:Point):Boolean{
		//if(Point.distance(pt, ellipse.position) <= ellipse.maxRadius){
			//if(ellipse.bounds.containsPoint(pt)){
				_contact.x = pt.x - ellipse.position.x;
				_contact.y = pt.y - ellipse.position.y;
				if(((_contact.x * _contact.x) * ellipse.squaredXRadius) + ((_contact.y * _contact.y) * ellipse.squaredYRadius) <= 1.0)
					return true;
			//}
		//}
		return false;
	}
//	private function checkEllipseIntersections(rect:Rectangle):int{
//		if(!_checkForEllipse)
//			return 0;
//		else{
//			for(var i:uint = 0 ; i < _ellipses.length ; i++){
//				var ellipse:EllipseData = _ellipses[i];
//				var returnVal:uint = 0;
//				if(ellipse){
//					if(ellipse.bounds.containsRect(rect)){
//						_verticeA.x = rect.x - ellipse.center.x;
//						_verticeA.y = rect.y - ellipse.center.y;
//						_verticeB.x = rect.x + rect.width - ellipse.center.x;
//						_verticeB.y = rect.y - ellipse.center.y;
//						_verticeC.x = rect.x + rect.width - ellipse.center.x;
//						_verticeC.y = rect.y + rect.height - ellipse.center.y;
//						_verticeD.x = rect.x - ellipse.center.x;
//						_verticeD.y = rect.y + rect.height - ellipse.center.y;
//						if(((_verticeA.x * _verticeA.x) / ellipse.squaredXRadius) + ((_verticeA.y * _verticeA.y) / ellipse.squaredYRadius) <= 1.0)
//							returnVal++;
//						if(((_verticeB.x * _verticeB.x) / ellipse.squaredXRadius) + ((_verticeB.y * _verticeB.y) / ellipse.squaredYRadius) <= 1.0)
//							returnVal++;
//						if(((_verticeC.x * _verticeC.x) / ellipse.squaredXRadius) + ((_verticeC.y * _verticeC.y) / ellipse.squaredYRadius) <= 1.0)
//							returnVal++;
//						if(((_verticeD.x * _verticeD.x) / ellipse.squaredXRadius) + ((_verticeD.y * _verticeD.y) / ellipse.squaredYRadius) <= 1.0)
//							returnVal++;
//					}
//				}
//			}
//			return returnVal;
//		}
//	}

//	private function getTotalPixels():uint
//	{
//		var pixels:uint = 0;
//		for(var i:uint = 0 ; i < _numSquares; i++){
//			var mo:MovingSquare = _pool[i] as MovingSquare;
//			pixels += mo.size * mo.size;
//		}
//		return pixels;
//	}

	public function update():void{
		var dt:Number = _genome2d.getCurrentFrameDeltaTime();
		if(_isTutorial){
			return;
		}
		if(!_paused && !_gameOver)
			_currentScore.time += dt;
			_hud.updateTime(_currentScore.time);
		var numTmp:uint = _current.length;
		for(var i:uint = 0 ; i < numTmp; i++){
			var mo:MovingSquare = _current[i] as MovingSquare;
			if(!_gameOver){
				if(!_paused && !_gameOver){
					if(mo.caughtBy == null){
						var intersects:Boolean = checkIntersectionsWithPoint(mo.center);
						if(!intersects){
							var currentSize:uint = mo.size;
							mo.update(dt);
							if(mo.hitWall != ""){
								if(mo.size != currentSize)
									_currentPixels += ((mo.size * mo.size) - ((mo.size - 2) * (mo.size - 2)));
								if(!_isTutorialStep2)
									createMovingObject(mo);
							}
						}else{
							mo.reverse();
							mo.update(dt);
						}
					}
				}
			}
			_context.draw(AssetsManager.SquareTexture,mo.center.x, mo.center.y, mo.scale, mo.scale,0,1,1,1,1,GBlendMode.NORMAL);
		}
		if(!_gameOver)
			_hud.updatePercent(uint(numTmp / Main.CURRENT_LEVEL.squaresGameOver * 100));
		if(numTmp >= Main.CURRENT_LEVEL.squaresGameOver && !_gameOver){
			_gameOver = true;
			_timer.stop();
			_hud.updatePercent(100);
			GameSignals.GAME_OVER.dispatch(false);
		}
	}
}
}
