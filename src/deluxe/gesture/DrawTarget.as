/**
 * Created with IntelliJ IDEA.
 * User: lvdeluxe
 * Date: 14-03-05
 * Time: 20:05
 * To change this template use File | Settings | File Templates.
 */
package deluxe.gesture {
import deluxe.GameSignals;
import deluxe.gesture.data.EllipseData;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

public class DrawTarget extends Sprite{

	private static var INC:uint = 0;
	private var _timer:Timer;
	public var data:EllipseData;
	private var _name:String;
	public var toBeDestoyed:Boolean = false;
	private var _controller:GestureController;

	public function DrawTarget(controller:GestureController) {
		_controller = controller;
		_timer = new Timer(10000,1);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onEllipseExplode);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		_name = "drawTarget_" + (++INC).toString();
	}

	private function onMouseMove(event:MouseEvent):void {
		trace("moved", _name);
		if(_controller.isMouseDown)
			toBeDestoyed = true;
	}

	private function onEllipseExplode(event:TimerEvent):void {
		GameSignals.ELLIPSE_EXPLODE.dispatch(this);
		_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onEllipseExplode);
		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		graphics.clear();
		parent.removeChild(this);
	}

	public function clear():void{
		graphics.clear();
		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		_timer.stop();
		_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onEllipseExplode);
		parent.removeChild(this);
	}

	public function drawShape(xPos:Number, yPos:Number, xRadius:Number, yRadius:Number):void{
		graphics.lineStyle(2, Math.random() * 0xffffff);
		graphics.beginFill(0xffffff, 0.25);
		graphics.drawEllipse(xPos, yPos, xRadius * 2, yRadius * 2);
		graphics.endFill();

	}

	public function setData(pData:EllipseData):void{
		data = pData;
		_timer.start();
	}
}
}
