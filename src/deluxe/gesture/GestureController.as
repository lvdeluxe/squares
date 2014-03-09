/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-02-25
 * Time: 19:42
 * To change this template use File | Settings | File Templates.
 */
package deluxe.gesture {
import deluxe.GameSignals;
import deluxe.gesture.data.EllipseData;
import deluxe.gesture.data.GestureTypes;

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Point;
import flash.utils.Timer;

import deluxe.gesture.data.GestureData;

public class GestureController {

	private var _stage:Stage;
	private var _px:uint;
	private var _py:int;
	private var _toDegrees:Number = 180 / Math.PI;
	private var _moves:Vector.<GestureData> = new Vector.<GestureData>();
	private var _maxMoves:uint = 10;
	private var _allTargets:Vector.<DrawTarget> = new Vector.<DrawTarget>();
	public var isMouseDown:Boolean = false;

	public function GestureController(stage:Stage) {
		_stage = stage;
		_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		GameSignals.ELLIPSE_EXPLODE.add(onExplode);
	}

	private function onExplode(drawTarget:DrawTarget):void {
		_allTargets.splice(_allTargets.indexOf(drawTarget), 1);
	}

	private function onMouseDown(event:MouseEvent):void {
		isMouseDown = true;
		_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_stage.addEventListener(Event.ENTER_FRAME, onFrame);
		_moves = new Vector.<GestureData>();
		_px = _stage.mouseX;
		_py = _stage.mouseY;
	}

	private function onFrame(event:Event):void {
		var currentMove:String = "";
		var dx:int = _px -_stage.mouseX;
		var dy:int =_py - _stage.mouseY;
		var distance:Number=dx*dx+dy*dy;
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
			if (angle>=135||angle<157*-1) {
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
		testGesture();
		_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		_stage.removeEventListener(Event.ENTER_FRAME, onFrame);
		isMouseDown = false;
	}

	private function testGesture():void {

		if(_moves.length > 0){
			var start:int = GestureTypes.CIRCLE_CLOCKWISE.indexOf(_moves[0].moveType);
			if(start != -1){
				var errors:uint =  _moves.length < GestureTypes.CIRCLE_CLOCKWISE.length ? GestureTypes.CIRCLE_CLOCKWISE.length - _moves.length : 0;
				var i:uint = 0;
				var index:uint = i + start;
				for (i ; i < _moves.length ; i++){
					if(index > GestureTypes.CIRCLE_CLOCKWISE.length - 1){
						index -= GestureTypes.CIRCLE_CLOCKWISE.length;
					}
					if(GestureTypes.CIRCLE_CLOCKWISE[index] != _moves[i].moveType){
						errors++;
						i--;
					}
					index++;
				}
			}

			if(errors <= 2){
				var drawTarget:DrawTarget = new DrawTarget(this);
				_stage.addChild(drawTarget);
				_moves = _moves.sort(sortOnMostLeftPoint);
				var xRadius:Number = (_moves[_moves.length - 1].position.x - _moves[0].position.x) / 2;
				var xPos:Number = _moves[0].position.x;

				_moves = _moves.sort(sortOnLowestPoint);

				var yRadius:Number = (_moves[_moves.length - 1].position.y - _moves[0].position.y) / 2;
				var yPos:Number = _moves[0].position.y;

				drawTarget.drawShape(xPos, yPos, xRadius, yRadius);


				var data:EllipseData = new EllipseData(xRadius, yRadius, xPos, yPos);
				drawTarget.setData(data);
				GameSignals.ELLIPSE_DRAW.dispatch(drawTarget);
//
				_allTargets.push(drawTarget);
				checkTargetsToDestroy();
			}else{
				GameSignals.ELLIPSE_DRAW.dispatch(null);
			}
		}
		_moves = new Vector.<GestureData>();
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


	private function sortOnMostLeftPoint(a:GestureData, b:GestureData):Number{
		return a.position.x - b.position.x;
	}


	private function sortOnLowestPoint(a:GestureData, b:GestureData):int{
		return a.position.y - b.position.y;
	}
}
}
