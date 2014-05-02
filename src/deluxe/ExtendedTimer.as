package deluxe{
	// An timer that can be paused.  Yes, yes, PAUSED!  The revolution starts now.
	// I found that code there:
	//http://blog.fjakobs.com/archives/101

import flash.events.TimerEvent;
import flash.utils.Timer;

public class ExtendedTimer extends Timer{

		private var _startTime:Number;
		private var _initialDelay:Number;
		private var _isPaused:Boolean = false;
		private var _autoPause:Boolean;

		public function ExtendedTimer(delay:Number, repeatCount:int = 0, addToAutoPause:Boolean = true){
			super(delay, repeatCount);
			_initialDelay = delay;
			_autoPause = addToAutoPause;
			addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
		}
		private function onTimer(event:TimerEvent):void {
			_startTime = new Date().time;
			delay = _initialDelay;
		}
		// timer continues from where it left off
		public function resume():void {
			if((currentCount < repeatCount) || (repeatCount == 0)){
				_isPaused = false;
				_startTime = new Date().time;
				super.start();
			}
		}
		override public function start():void {
			if((currentCount < repeatCount) || (repeatCount == 0)){
				delay = _initialDelay; // added to “reset” timer
				_isPaused = false;
				_startTime = new Date().time;
				super.start();
			}
		}
		public function pause():void {
			if(running)	{
				_isPaused = true;
				stop();
				var thisDelay:Number = delay - (new Date().time - _startTime);
				if (thisDelay <= 0) {
					thisDelay = 1;
				}
				delay = thisDelay;
			}
		}
		public function get paused():Boolean{
			return _isPaused;
		}
		public function get initialDelay():Number{
			return _initialDelay;
		}

		public function destroy():void {
			stop();
		}
	}
}