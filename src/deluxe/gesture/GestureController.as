/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-25
 * Time: 19:42
 * To change this template use File | Settings | File Templates.
 */
package deluxe.gesture {
import com.genome2d.Genome2D;
import com.genome2d.node.factory.GNodeFactory;

import deluxe.GameSignals;
import deluxe.SoundsManager;
import deluxe.gesture.data.EllipseData;
import deluxe.gesture.data.GestureTypes;
import deluxe.gesture.data.IGeometryData;
import deluxe.gesture.data.RectangleData;
import deluxe.gesture.data.TriangleData;
import deluxe.particles.GestureParticles;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Timer;

import deluxe.gesture.data.GestureData;

public class GestureController {

	private var _stage:Stage;
	private var _px:uint;
	private var _py:int;
	private var _toDegrees:Number = 180 / Math.PI;
	private var _moves:Vector.<GestureData> = new Vector.<GestureData>();
	private var _triangleBuffer:Vector.<Point> = new Vector.<Point>();
	private var _maxMoves:uint = 10;
	private var _allTargets:Vector.<DrawTarget> = new Vector.<DrawTarget>();
	public var isMouseDown:Boolean = false;
	private var _particles:GestureParticles;
	private var _paused:Boolean = false;

	private var _circleMaxError:uint = 2;
	private var _triangleMaxError:uint = 1;
	private var _rectangleMaxError:uint = 1;

	private var _firstIndexGeometry:uint;

	private var _tutStep1Position:Point;

	private var _realGestureExplosionSpeed:uint;

	private var _alreadyStartedTutorialStep1:Boolean = false;

	public function GestureController(stage:Stage) {
		_stage = stage;
		GameSignals.ELLIPSE_EXPLODE.add(onExplode);
		GameSignals.TUT_STEP_1_START.add(onTutorialStep1);
		GameSignals.TUTORIAL_COMPLETE.add(onTutorialComplete);
		_particles = GNodeFactory.createNodeWithComponent(GestureParticles) as GestureParticles;
		_particles.node.setActive(false);
	}

	private function onTutorialComplete():void {
		_tutStep1Position = null;
	}

	private function onTutorialStep1(pos:Point):void{
		_tutStep1Position = pos;
		_realGestureExplosionSpeed = Main.CURRENT_LEVEL.gestureExplosionSpeed;
		Main.CURRENT_LEVEL.gestureExplosionSpeed = 5000;
		Main.CURRENT_LEVEL.gestureExplosionSpeedMilli = Main.CURRENT_LEVEL.gestureExplosionSpeed / 1000;
		_particles.setEnergy(Main.CURRENT_LEVEL.gestureExplosionSpeed);
	}

	public function startLevel():void{
		_particles.setEnergy(Main.CURRENT_LEVEL.gestureExplosionSpeed);
		_particles.node.setActive(true);
		_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}

	private function onExplode(drawTarget:DrawTarget):void {
		_allTargets.splice(_allTargets.indexOf(drawTarget), 1);
		SoundsManager.playExplodeSfx();
		if(_tutStep1Position != null){
			GameSignals.TUT_STEP_3_COMPLETE.dispatch();
		}
	}

	public function setGameOverState():void{
		_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		for(var i:int = _allTargets.length - 1 ; i >= 0 ; i--){
			var target:DrawTarget = _allTargets[i] as DrawTarget;
			target.clear();
		}
		_allTargets = new Vector.<DrawTarget>();
		_particles.node.setActive(false);
		_particles.emit = false;
		if(isMouseDown){
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_stage.removeEventListener(Event.ENTER_FRAME, onFrame);
			_moves = new Vector.<GestureData>();
		}
	}

	public function cleanup():void{


	}

	public function pause():void{
		_paused = true;
		_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		for(var i:int = _allTargets.length - 1 ; i >= 0 ; i--){
			var target:DrawTarget = _allTargets[i] as DrawTarget;
			target.pauseTimer();
		}
		_particles.node.setActive(false);
	}
	public function resume():void{
		_paused = false;
		_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		for(var i:int = _allTargets.length - 1 ; i >= 0 ; i--){
			var target:DrawTarget = _allTargets[i] as DrawTarget;
			target.resumeTimer();
		}
		_particles.node.setActive(true);
	}

	private function onMouseDown(event:MouseEvent):void {
		if(_tutStep1Position == null || isValidTouchPosition(_stage.mouseX, _stage.mouseY)){
			SoundsManager.startLooper();
			isMouseDown = true;
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_stage.addEventListener(Event.ENTER_FRAME, onFrame);
			_moves = new Vector.<GestureData>();
			_px = _stage.mouseX;
			_py = _stage.mouseY;
			_particles.node.transform.setPosition(_px, _py);
			_particles.emit = true;
		}
	}

	private function isValidTouchPosition(stageX:Number, stageY:Number):Boolean{
		var offset:Number = 50;
		var rect:Rectangle = new Rectangle(_tutStep1Position.x - offset / 2, _tutStep1Position.y - offset / 2, offset, offset);
		if(rect.contains(stageX,stageY) && !_alreadyStartedTutorialStep1){
			GameSignals.TUT_STEP_1_COMPLETE.dispatch();
			_alreadyStartedTutorialStep1 = true;
		}
		return rect.contains(stageX,stageY);
	}

	private function onFrame(event:Event):void {
		_particles.node.transform.setPosition(_stage.mouseX, _stage.mouseY);
		var currentMove:String = "";
		var dx:int = _px -_stage.mouseX;
		var dy:int =_py - _stage.mouseY;
		_triangleBuffer.push(new Point(_stage.mouseX, _stage.mouseY));
		var distance:Number=dx*dx+dy*dy;
		SoundsManager.pitchLooper(Math.sqrt(distance) / 35);
		if (distance>400) {
			var angle:Number=Math.atan2(dy,dx) * _toDegrees;
			if (angle>=22*-1&&angle<23) {
				currentMove = GestureTypes.MOVE_LEFT;
			}
			if (angle>=23&&angle<68) {
				currentMove = GestureTypes.MOVE_LEFT_UP;
			}
			if (angle>=68&&angle<113) {
				currentMove = GestureTypes.MOVE_UP;
			}
			if (angle>=113&&angle<158) {
				currentMove = GestureTypes.MOVE_RIGHT_UP;
			}
			if (angle>=158||angle<157*-1) {
				currentMove = GestureTypes.MOVE_RIGHT;
			}
			if (angle>=157*-1&&angle<112*-1) {
				currentMove = GestureTypes.MOVE_RIGHT_DOWN;
			}
			if (angle>=112*-1&&angle<67*-1) {
				currentMove = GestureTypes.MOVE_DOWN;
			}
			if (angle>=67*-1&&angle<22*-1) {
				currentMove = GestureTypes.MOVE_LEFT_DOWN;
			}
			_px = _stage.mouseX;
			_py = _stage.mouseY;
		}
		if(currentMove != ""){
			if(_moves.length == 0 || _moves[_moves.length - 1].moveType != currentMove)
				_moves.push(new GestureData(currentMove, new Point(_stage.mouseX, _stage.mouseY)));
		}
		if(_moves.length > _maxMoves)
			_moves.shift();
	}

	private function onMouseUp(event:MouseEvent):void {
		SoundsManager.stopLooper();
		_particles.emit = false;
		testGesture();
		_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_stage.removeEventListener(Event.ENTER_FRAME, onFrame);
		isMouseDown = false;
	}

	private function testGesture():void {
		if(_moves.length > 0){
			var testCircleClockWise:DrawTarget = testEllipse(GestureTypes.CIRCLE_CLOCKWISE, _circleMaxError, "circle_gesture", setEllipseData);
			if(testCircleClockWise != null){
				_allTargets.push(testCircleClockWise);
				checkTargetsToDestroy();
				GameSignals.GESTURE_DRAW.dispatch(testCircleClockWise);
				if(_tutStep1Position != null){
					GameSignals.TUT_STEP_2_COMPLETE.dispatch(testCircleClockWise);
					Main.CURRENT_LEVEL.gestureExplosionSpeed = _realGestureExplosionSpeed;
					Main.CURRENT_LEVEL.gestureExplosionSpeedMilli = Main.CURRENT_LEVEL.gestureExplosionSpeed / 1000;
					_particles.setEnergy(Main.CURRENT_LEVEL.gestureExplosionSpeed);
				}
			}else{
				if(_tutStep1Position != null)
					return;
				var testCircleCounterClockWise:DrawTarget = testEllipse(GestureTypes.CIRCLE_COUNTER_CLOCKWISE, _circleMaxError, "circle_gesture", setEllipseData);
				if(testCircleCounterClockWise != null){
					_allTargets.push(testCircleCounterClockWise);
					checkTargetsToDestroy();
					GameSignals.GESTURE_DRAW.dispatch(testCircleCounterClockWise);
				}
				else{
					var testTriangleUpClockWise:DrawTarget = testTriangle(GestureTypes.TRIANGLE_UP_CLOCKWISE, _triangleMaxError, "triangle_gesture", setTriangleData);
					if(testTriangleUpClockWise != null){
						_allTargets.push(testTriangleUpClockWise);
						checkTargetsToDestroy();
						GameSignals.GESTURE_DRAW.dispatch(testTriangleUpClockWise);
					}
					else{
						var testTriangleUpCounterClockWise:DrawTarget = testTriangle(GestureTypes.TRIANGLE_UP_COUNTER_CLOCKWISE, _triangleMaxError, "triangle_gesture", setTriangleData);
						if(testTriangleUpCounterClockWise != null){
							_allTargets.push(testTriangleUpCounterClockWise);
							checkTargetsToDestroy();
							GameSignals.GESTURE_DRAW.dispatch(testTriangleUpCounterClockWise);
						}else{
							var testTriangleDownClockWise:DrawTarget = testTriangle(GestureTypes.TRIANGLE_DOWN_CLOCKWISE, _triangleMaxError, "triangle_gesture", setTriangleData);
							if(testTriangleDownClockWise != null){
								_allTargets.push(testTriangleDownClockWise);
								checkTargetsToDestroy();
								GameSignals.GESTURE_DRAW.dispatch(testTriangleDownClockWise);
							}else{
								var testTriangleDownCounterClockWise:DrawTarget = testTriangle(GestureTypes.TRIANGLE_DOWN_COUNTER_CLOCKWISE, _triangleMaxError, "triangle_gesture", setTriangleData);
								if(testTriangleDownCounterClockWise != null){
									_allTargets.push(testTriangleDownCounterClockWise);
									checkTargetsToDestroy();
									GameSignals.GESTURE_DRAW.dispatch(testTriangleDownCounterClockWise);
								}else{
									var testTriangleLeftClockWise:DrawTarget = testTriangle(GestureTypes.TRIANGLE_LEFT_CLOCKWISE, _triangleMaxError, "triangle_gesture", setTriangleData);
									if(testTriangleLeftClockWise != null){
										_allTargets.push(testTriangleLeftClockWise);
										checkTargetsToDestroy();
										GameSignals.GESTURE_DRAW.dispatch(testTriangleLeftClockWise);
									}else{
										var testTriangleLeftCounterClockWise:DrawTarget = testTriangle(GestureTypes.TRIANGLE_LEFT_COUNTER_CLOCKWISE, _triangleMaxError, "triangle_gesture", setTriangleData);
										if(testTriangleLeftCounterClockWise != null){
											_allTargets.push(testTriangleLeftCounterClockWise);
											checkTargetsToDestroy();
											GameSignals.GESTURE_DRAW.dispatch(testTriangleLeftCounterClockWise);
										}else{
											var testTriangleRightClockWise:DrawTarget = testTriangle(GestureTypes.TRIANGLE_RIGHT_CLOCKWISE, _triangleMaxError, "triangle_gesture", setTriangleData);
											if(testTriangleRightClockWise != null){
												_allTargets.push(testTriangleRightClockWise);
												checkTargetsToDestroy();
												GameSignals.GESTURE_DRAW.dispatch(testTriangleRightClockWise);
											}else{
												var testTriangleRightCounterClockWise:DrawTarget = testTriangle(GestureTypes.TRIANGLE_RIGHT_COUNTER_CLOCKWISE, _triangleMaxError, "triangle_gesture", setTriangleData);
												if(testTriangleRightCounterClockWise != null){
													_allTargets.push(testTriangleRightCounterClockWise);
													checkTargetsToDestroy();
													GameSignals.GESTURE_DRAW.dispatch(testTriangleRightCounterClockWise);
												}else{
													var testRectangleClockWise:DrawTarget = testRectangle(GestureTypes.RECTANGLE_CLOCKWISE, _rectangleMaxError, "rectangle_gesture", setRectangleData);
													if(testRectangleClockWise != null){
														_allTargets.push(testRectangleClockWise);
														checkTargetsToDestroy();
														GameSignals.GESTURE_DRAW.dispatch(testRectangleClockWise);
													}else{
														var testRectangleCounterClockWise:DrawTarget = testRectangle(GestureTypes.RECTANGLE_COUNTER_CLOCKWISE, _rectangleMaxError, "rectangle_gesture", setRectangleData);
														if(testRectangleCounterClockWise != null){
															_allTargets.push(testRectangleCounterClockWise);
															checkTargetsToDestroy();
															GameSignals.GESTURE_DRAW.dispatch(testRectangleCounterClockWise);
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		_moves = new Vector.<GestureData>();
		_triangleBuffer = new Vector.<Point>();
	}

	private function testRectangle(geometry:Vector.<String>, maxError:uint, textureId:String, dataCallback:Function):DrawTarget {
		var movesCopy:Vector.<GestureData> = _moves.slice();
		if(movesCopy.length < 4)
			return null;
		var arrMatch:Array = [];
		for (var i:uint = 0; i < movesCopy.length ; i++){
			var moveType:String = movesCopy[i].moveType;
			var iTmp:int = geometry.indexOf(moveType);
			arrMatch.push(iTmp);
		}

		var arrLength:uint = arrMatch.length;
		arrMatch = arrMatch.filter(removeUnset);

		if(arrLength - arrMatch.length > maxError)
			return null;

		_firstIndexGeometry = arrMatch[0];
		arrMatch = arrMatch.map(offsetTriangleIndexes);

		if(String(arrMatch.slice(0,4)) == String([0,1,2,3])){
			var drawTarget:DrawTarget = new DrawTarget(this, textureId);
			Genome2D.getInstance().root.addChild(drawTarget);
			drawTarget.setData(dataCallback(movesCopy, geometry));
			return drawTarget;
		}

		return null;
	}
	private function testTriangle(geometry:Vector.<String>, maxError:uint, textureId:String, dataCallback:Function):DrawTarget {
		var movesCopy:Vector.<GestureData> = _moves.slice();
		if(movesCopy.length < 3)
			return null;

		var arrMatch:Array = [];
		for (var i:uint = 0; i < movesCopy.length ; i++){
			var moveType:String = movesCopy[i].moveType;
			var iTmp:int = geometry.indexOf(moveType);
			arrMatch.push(iTmp);
		}

		var arrLength:uint = arrMatch.length;
		arrMatch = arrMatch.filter(removeUnset);

		if(arrLength - arrMatch.length > maxError)
			return null;

		_firstIndexGeometry = arrMatch[0];
		arrMatch = arrMatch.map(offsetTriangleIndexes);

		if(String(arrMatch.slice(0,3)) == String([0,1,2])){
			var drawTarget:DrawTarget = new DrawTarget(this, textureId);
			Genome2D.getInstance().root.addChild(drawTarget);
			drawTarget.setData(dataCallback(movesCopy, geometry));
			return drawTarget;
		}
		return null;
	}

	private function offsetTriangleIndexes(item:int, index:int, array:Array):uint{
		item -= _firstIndexGeometry;
		if(item < 0)
			item += array.length;
		return item;
	}

	private function removeUnset(item:int, index:int, array:Array):Boolean{
		return item >= 0;
	}

	private function testEllipse(geometry:Vector.<String>, maxError:uint, textureId:String, dataCallback:Function):DrawTarget {
		var movesCopy:Vector.<GestureData> = _moves.slice();
		var start:int = geometry.indexOf(movesCopy[0].moveType);
		if(start != -1){
			if(movesCopy.length < 3)
				return null;
			var errors:uint =  movesCopy.length < geometry.length ? geometry.length - movesCopy.length : 0;
			var i:uint = 0;
			var index:uint = i + start;
			var indexCount:uint = 0;
			for (i = 0; i < movesCopy.length ; i++){
				if(index > geometry.length - 1){
					index -= geometry.length;
				}
				if(geometry[index] != movesCopy[i].moveType){
					errors++;
					index--;
				}
				index++;
				indexCount++;
				if(indexCount > movesCopy.length -1)
					break;
			}
			if(errors <= maxError){
				var drawTarget:DrawTarget = new DrawTarget(this, textureId);
				Genome2D.getInstance().root.addChild(drawTarget);
				drawTarget.setData(dataCallback(movesCopy, geometry));
				return drawTarget;
			}
		}

		return null;
	}

	private function setRectangleData(movesTmp:Vector.<GestureData>, geometry:Vector.<String>):IGeometryData{
		_triangleBuffer = _triangleBuffer.sort(sortPointOnMostLeftPoint);
		var width:Number = _triangleBuffer[_triangleBuffer.length - 1].x - _triangleBuffer[0].x;
		var xPos:Number = _triangleBuffer[0].x;

		_triangleBuffer = _triangleBuffer.sort(sortPointOnLowestPoint);
		var height:Number = _triangleBuffer[_triangleBuffer.length - 1].y - _triangleBuffer[0].y;
		var yPos:Number = _triangleBuffer[0].y;
		var data:RectangleData = new RectangleData(new Rectangle(xPos, yPos, width, height));
		return data;
	}

	private function setTriangleData(movesTmp:Vector.<GestureData>, geometry:Vector.<String>):IGeometryData{

		_triangleBuffer = _triangleBuffer.sort(sortPointOnMostLeftPoint);
		var width:Number = _triangleBuffer[_triangleBuffer.length - 1].x - _triangleBuffer[0].x;
		var xPos:Number = _triangleBuffer[0].x + (width / 2);

		_triangleBuffer = _triangleBuffer.sort(sortPointOnLowestPoint);
		var height:Number = _triangleBuffer[_triangleBuffer.length - 1].y - _triangleBuffer[0].y;
		var yPos:Number = _triangleBuffer[0].y + (height / 2);

		var data:TriangleData = new TriangleData(xPos, yPos, width, height, geometry);
		return data;
	}

	private function setEllipseData(movesTmp:Vector.<GestureData>, geometry:Vector.<String>):IGeometryData{
		movesTmp = movesTmp.sort(sortOnMostLeftPoint);
		var xRadius:Number = (movesTmp[movesTmp.length - 1].position.x - movesTmp[0].position.x) / 2;
		var xPos:Number = movesTmp[0].position.x;

		movesTmp = movesTmp.sort(sortOnLowestPoint);

		var yRadius:Number = (movesTmp[movesTmp.length - 1].position.y - movesTmp[0].position.y) / 2;
		var yPos:Number = movesTmp[0].position.y;

		var data:EllipseData = new EllipseData(xRadius, yRadius, xPos, yPos);
		return data;
	}


	private function testCircle(circle:Vector.<String>, maxError:uint, textureId:String):DrawTarget{
		var start:int = circle.indexOf(_moves[0].moveType);
		if(start != -1){
			var errors:uint =  _moves.length < circle.length ? circle.length - _moves.length : 0;
			var i:uint = 0;
			var index:uint = i + start;
			for (i ; i < _moves.length ; i++){
				if(index > circle.length - 1){
					index -= circle.length;
				}
				if(circle[index] != _moves[i].moveType){
					errors++;
					i--;
				}
				index++;
			}

			if(errors <= 2){
				var drawTarget:DrawTarget = new DrawTarget(this, "circle_gesture");
				Genome2D.getInstance().root.addChild(drawTarget);

				_moves = _moves.sort(sortOnMostLeftPoint);
				var xRadius:Number = (_moves[_moves.length - 1].position.x - _moves[0].position.x) / 2;
				var xPos:Number = _moves[0].position.x;

				_moves = _moves.sort(sortOnLowestPoint);

				var yRadius:Number = (_moves[_moves.length - 1].position.y - _moves[0].position.y) / 2;
				var yPos:Number = _moves[0].position.y;

				var data:EllipseData = new EllipseData(xRadius, yRadius, xPos, yPos);
				drawTarget.setData(data);

				return drawTarget;
			}
		}
		return null;
	}


	private function checkTargetsToDestroy():void {
		for(var i:int = _allTargets.length - 1 ; i >= 0 ; i--){
			var target:DrawTarget = _allTargets[i] as DrawTarget;
			if(target.toBeDestoyed){
				_allTargets.splice(i, 1);
				target.clear();
				GameSignals.ELLIPSE_CANCEL.dispatch(target);
				target = null;
			}
		}
	}


	private function sortPointOnMostLeftPoint(a:Point, b:Point):Number{
		return a.x - b.x;
	}


	private function sortPointOnLowestPoint(a:Point, b:Point):int{
		return a.y - b.y;
	}

	private function sortOnMostLeftPoint(a:GestureData, b:GestureData):Number{
		return a.position.x - b.position.x;
	}


	private function sortOnLowestPoint(a:GestureData, b:GestureData):int{
		return a.position.y - b.position.y;
	}
}
}
